import scala.reflect.{ClassTag, classTag}

class Parser(var tokenList: List[Token]){
  
  def getStart() : Position = tokenList(0).getPosition()

  def eatIf[astClassName <: Token]()(implicit cTag : ClassTag[astClassName]): Token = {
    if(!(tokenList.isEmpty)){
      if(shouldEat[astClassName]()(cTag)){
        return eat()
      } else {
        sys.error("Error: Expected " + cTag.runtimeClass.getCanonicalName + " but found " + tokenList(0).toString())
        return null
      }
    } else {
      sys.error("Error: Unexpected end of file found while matching token")
      return null
    }
  }

  def eat(): Token = {
    if(!(tokenList.isEmpty)){
      val initElem = tokenList(0)
      tokenList = tokenList.tail
      return initElem
    } else {
      sys.error("Error: Unexpected end of file found while eating token")
      return null
    }
  }

  def eatIfYummy[astClassName <: Token]()(implicit cTag : ClassTag[astClassName]): Boolean = {
    if(shouldEat[astClassName]()(cTag)){
      eat()
      return true
    } else {
      return false
    }
  }

  def shouldEat[astClassName <: Token]()(implicit cTag : ClassTag[astClassName]): Boolean = {
    if(!(tokenList.isEmpty)){
      val tok: Token = tokenList(0)
      return cTag.runtimeClass.isInstance(tok)
    } else {
      return false
    }
  }

  def parseStatement(): Statement = {
    tokenList match{
      case IDENT(_,_) :: LPAR(_) :: _ => parseFunctionDeclaration()
      case IDENT(_,_) :: EQ(_) :: _ => parseAssignment()
      case _ => parsePrintExpression()
    }
  }

  def parsePrintExpression(): PrintExpression = {
    val start: Position = getStart()
    val expr: Expression = parseExpression()
    return new PrintExpression(expr, start)
  }

  def parseAssignment(): Assignment = {
    val start: Position = getStart()
    val lexeme: String = eatIf[IDENT]().getLexeme()
    eatIf[EQ]()
    val expr: Expression = parseExpression()
    return new Assignment(lexeme, expr, start)
  }

  def parseFunctionDeclaration(): FunctionDeclaration = {
    val start: Position = getStart()
    val lexeme: String = eatIf[IDENT]().getLexeme()
    eatIf[LPAR]()
    var argList: List[String] = List[String]()

    do {
      val arg: String = eatIf[IDENT].getLexeme()
      argList = arg :: argList 
    } while(eatIfYummy[COMMA]())

    eatIf[RPAR]()

    eatIf[EQ]()

    val exp: Expression = parseExpression()

    return new FunctionDeclaration(lexeme, argList.reverse, exp, start)
  }

  def parseExpression(): Expression = parseAddExpression()

  def parseAddExpression(): Expression = {
    val start: Position = getStart()
    var exp1 : Expression = parseMultExpression()

    while(shouldEat[PLUS]() || shouldEat[MINUS]()){
      val tok: Token = eat()
      val exp2: Expression = parseMultExpression()
      if(tok.isInstanceOf[PLUS]){
        exp1 = new Add(exp1, exp2, start)
      } else {
        exp1 = new Subtract(exp1, exp2, start)
      }
    }
    return exp1
  }

  def parseMultExpression(): Expression = {
    val start: Position = getStart()
    var exp1 : Expression = parseUnaryExpression()

    while(shouldEat[TIMES]() || shouldEat[DIV]()){
      val tok: Token = eat()
      val exp2: Expression = parseUnaryExpression()
      if(tok.isInstanceOf[TIMES]){
        exp1 = new Times(exp1, exp2, start)
      } else {
        exp1 = new Divide(exp1, exp2, start)
      }
    }

    return exp1
  }

  def parseUnaryExpression(): Expression = {
    val start: Position = getStart()

    if(eatIfYummy[MINUS]){
      val exp: Expression = parseUnaryExpression()
      return new Negate(exp, start)
    } else {
      return parseExponentExpression()
    }
  }

  def parseExponentExpression(): Expression = {
    val start: Position = getStart()

    var exp1: Expression = parsePrimaryExpression()

    if(eatIfYummy[EXP]){
      var exp2: Expression = parseUnaryExpression()
      return new Exponent(exp1, exp2, start)
    } else {
      return exp1
    }
  }

  def parsePrimaryExpression(): Expression = {
    tokenList match{
      case LCURL(_) :: _ => parseSetExpression()
      case LPAR(_) :: IDENT(_,_) :: OF(_) :: _ => parseCompositionExpression()
      case LPAR(_) :: _ => parseParExpression()
      case IDENT(_,_) :: LPAR(_) :: _ => parseFunctionExpression()
      case IDENT(_,_) :: _ => parseIdentifier()
      case DOLLAR(_) :: _ => parseDollarExpression()
      case INT(_,_) :: _ => parseInteger()
      case REAL(_,_) :: _ => parseReal()
      case a :: _ => println("Error: unexpected " + a.toString() + " found"); return null
    }
  }

  def parseDollarExpression(): Expression = {
    val start: Position = getStart()

    eatIf[DOLLAR]()
    if(shouldEat[IDENT]()){
      val ident: Identifier = new Identifier(eatIf[IDENT]().getLexeme(), start)
      return new Dollar(ident, start)
    } else if(shouldEat[INT]()) {
      val int_val: Integer = new Integer(eatIf[INT]().getLexeme(), start)
      return new Dollar(int_val, start)
    } else {
      val real_val: Real = new Real(eatIf[REAL]().getLexeme(), start)
      return new Dollar(real_val, start)
    }
  }

  def parseParExpression(): Expression = {
    val start: Position = getStart()

    eatIf[LPAR]()

    val expr: Expression = parseExpression()
    
    if(eatIfYummy[COMMA]()){
      var exprList: List[Expression] = List[Expression](expr)
      do{
        val tuple_expr: Expression = parseConstantExpression()
        exprList = tuple_expr :: exprList
      }while(eatIfYummy[COMMA]())

      eatIf[RPAR]()

      return new Tuple(exprList.reverse, start)
    } else {
      eatIf[RPAR]()
      return expr
    }
  }

  def parseFunctionExpression(): FunctionExpression = {
    val start: Position = getStart()

    val lexeme: String = eatIf[IDENT]().getLexeme()
    eatIf[LPAR]()

    var argList: List[Expression] = List[Expression]()

    do{
      val expr: Expression = parseExpression()
      argList = expr :: argList
    }while(eatIfYummy[COMMA])

    eatIf[RPAR]()

    return new FunctionExpression(lexeme, argList, start)
  }

  def parseIdentifier(): Expression = {
    val start: Position = getStart()

    val ident: Identifier = new Identifier(eatIf[IDENT]().getLexeme(), start)

    if(eatIfYummy[PERCENT]()){
      return new Percent(ident, start)
    } else {
      return ident
    }
  }

  def parseInteger(): Expression = {
    val start: Position = getStart()

    val int_val: Integer = new Integer(eatIf[INT]().getLexeme(), start)

    if(eatIfYummy[PERCENT]()){
      return new Percent(int_val, start)
    } else {
      return int_val
    }
  }

  def parseReal(): Expression = {
    val start: Position = getStart()

    val int_val: Real = new Real(eatIf[REAL]().getLexeme(), start)

    if(eatIfYummy[PERCENT]()){
      return new Percent(int_val, start)
    } else {
      return int_val
    }
  }

  def parseSetExpression(): Set = {
    val start: Position = getStart()
    var argList: List[ConstantExpression] = List[ConstantExpression]()

    eatIf[LCURL]()

    do{
      val arg: ConstantExpression = parseConstantExpression()
      argList = arg :: argList
    } while(eatIfYummy[COMMA]())

    eatIf[RCURL]()

    return new Set(argList.reverse, start)
  }

  def parseCompositionExpression(): CompositionExpression = {

    val start: Position = getStart()
    eatIf[LPAR]()

    var compArgs: List[String] = List[String]()

    do{
      val lexeme: String = eatIf[IDENT].getLexeme()
      compArgs = lexeme :: compArgs
    } while(eatIfYummy[OF]())

    eatIf[RPAR]()

    //now we need to parse the argument names

    var regArgs: List[ConstantExpression] = List[ConstantExpression]()
    eatIf[LPAR]()
    
    do{
      val expr: ConstantExpression = parseConstantExpression()
      regArgs = expr :: regArgs
    } while(eatIfYummy[COMMA]())

    eatIf[RPAR]()

    return new CompositionExpression(compArgs, regArgs.reverse, start)
  }

  def parseConstantExpression(): ConstantExpression = {
    val start: Position = getStart()
    val exp: Expression = parseExpression()
    return new ConstantExpression(exp, start)
  }

  
}