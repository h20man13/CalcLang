package calclang.parser

import calclang.parser.ast._
import calclang.lexer.token._
import calclang.Position

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

  def throwError(message: String): Nothing = {
    println(message)
    sys.exit()
  }

  def parseLine(): AstNode = tokenList match{
    case COLON(_) :: _ => parseCommand()
    case _ => parseStatement()
  }

  def parseCommand(): Command = tokenList match{
    case COLON(_) :: IDENT("Variables", _) :: _ => parseListVariables()
    case COLON(_) :: IDENT("Functions", _) :: _ => parseListFunctions()
    case COLON(_) :: IDENT("Delete", _) :: _ => parseDelete()
    case COLON(_) :: IDENT(a, _) :: _ => throwError("Unknon command found " + a)
    case _ => throwError("Expected colon but none found")
  }

  def parseListVariables(): Command = {
    val start: Position = getStart()
    eatIf[COLON]()
    val lexeme: String = eatIf[IDENT]().toString
    lexeme match {
      case "Variables" => new ListVariables(start)
      case _ => throwError(s"Expected Variables but found $lexeme")
    }
  }

  def parseListFunctions(): Command = {
    val start: Position = getStart()
    eatIf[COLON]()
    val lexeme: String = eatIf[IDENT]().toString
    lexeme match {
      case "Functions" => new ListFunctions(start)
      case _ => throwError(s"Expected Functions but found $lexeme")
    }
  }

  def parseDelete(): Command = {
    val pos: Position = getStart()
    eatIf[COLON]()
    eatIf[IDENT]()
    
    val lexeme: String = eatIf[IDENT]().toString
    if(lexeme == "Variables"){
      return new DeleteVariables(pos)
    } else if(lexeme == "Variable"){
      val variableToDel: String = eatIf[IDENT]().toString
      return new DeleteVariable(lexeme, pos)
    } else if(lexeme == "Functions"){
      return new DeleteFunctions(pos)
    } else if(lexeme == "Function"){
      val functionToDel: String = eatIf[IDENT]().toString
      return new DeleteFunction(functionToDel, pos)
    } else if(lexeme == "Cache"){
      return new DeleteCache(pos)
    } else {
      return new EmptyCommand(pos)
    }
  }


  def parseStatement(): Statement = tokenList match{
      case IDENT(_,_) :: LPAR(_) :: _ => parseFunctionDeclaration()
      case IDENT(_,_) :: IS(_) :: _ => parseAssignment()
      case _ => parsePrintExpression()
  }



  def parsePrintExpression(): PrintExpression = {
    val start: Position = getStart()
    val expr: Expression = parseExpression()
    return new PrintExpression(expr, start)
  }

  def parseAssignment(): Assignment = {
    val start: Position = getStart()
    val lexeme: String = eatIf[IDENT]().getLexeme()
    eatIf[IS]()
    val expr: Expression = parseExpression()
    return new Assignment(lexeme, expr, start)
  }

  def identToString(x: Expression): String = {
    x match {
      case Identifier(lexeme, pos) => lexeme
      case a => sys.error("Expected Identifier but found " + a.toString())
    }
  } 

  def parseFunctionDeclaration(): Statement = {
    val start: Position = getStart()
    val lexeme: String = eatIf[IDENT]().getLexeme()
    eatIf[LPAR]()
    var argList: List[Expression] = List[Expression]()

    do {
      val arg: Expression = parseExpression()
      argList = arg :: argList 
    } while(eatIfYummy[COMMA]())

    eatIf[RPAR]()

    if(eatIfYummy[IS]()){
      val exp: Expression = parseExpression()
      val strList: List[String] = argList.map(x => identToString(x))
      return new FunctionDeclaration(lexeme, strList.reverse, exp, start)
    } else if(shouldEat[AND]() || shouldEat[OR]()) {
      val funcExpr = new FunctionExpression(lexeme, argList.reverse, start)
      return new PrintExpression(parseAndExpression(funcExpr), start)
    } else if(shouldEat[EQ]() || shouldEat[GTE]() || shouldEat[GT]() || shouldEat[LTE] || shouldEat[LT]()) {
      val funcExpr = new FunctionExpression(lexeme, argList.reverse, start)
      return new PrintExpression(parseEqExpression(funcExpr), start)
    } else if(shouldEat[PLUS]() || shouldEat[MINUS]()){
      val funcExpr = new FunctionExpression(lexeme, argList.reverse, start)
      return new PrintExpression(parseAddExpression(funcExpr), start)
    } else if(shouldEat[TIMES]() || shouldEat[DIV]()){
      val funcExpr = new FunctionExpression(lexeme, argList.reverse, start)
      return new PrintExpression(parseMultExpression(funcExpr), start)
    } else if(shouldEat[EXP]()){
      val funcExpr = new FunctionExpression(lexeme, argList.reverse, start)
      return new PrintExpression(parseExponentExpression(funcExpr), start)
    } else {
      return new PrintExpression(new FunctionExpression(lexeme, argList.reverse, start), start)
    }
  }

  def parseExpression(): Expression = parseIfExpression()

  def parseIfExpression(): Expression = {
    val start: Position = getStart()

    if(shouldEat[IF]()){
      eat()
      val condition: Expression = parseAndExpression()
      eatIf[THEN]()
      val expressionTrue: Expression = parseExpression()
      eatIf[ELSE]()
      val expressionFalse: Expression = parseExpression()
      return new IfExpression(condition, expressionTrue, expressionFalse, start)
    } else {
      return parseAndExpression()
    }
   
  }

  def parseAndExpression(paramExp1 : Expression = new EmptyExpression(new Position(0))): Expression = {
    val start: Position = getStart()

    var exp1: Expression = if(paramExp1.isInstanceOf[EmptyExpression]){
      parseEqExpression()
    } else {
      paramExp1
    }

    while(shouldEat[AND]() || shouldEat[OR]()){
        val tok: Token = eat()
        val exp2: Expression = parseEqExpression()
        if(tok.isInstanceOf[AND]){
          exp1 = new And(exp1, exp2, start)
        } else {
          exp1 = new Or(exp1, exp2, start)
        }
    }

    return exp1
  }


  def parseEqExpression(paramExp1 : Expression = new EmptyExpression(new Position(0))): Expression = {
    val start: Position = getStart()

    var exp1: Expression = if(paramExp1.isInstanceOf[EmptyExpression]){
      parseAddExpression()
    } else {
      paramExp1
    }

    if(shouldEat[LT]() || shouldEat[GT]() || shouldEat[EQ]() || shouldEat[GTE]() || shouldEat[LTE]()){
        val tok: Token = eat()
        val exp2: Expression = parseAddExpression()
        if(tok.isInstanceOf[LT]){
          exp1 = new Less(exp1, exp2, start)
        } else if(tok.isInstanceOf[LTE]) {
          exp1 = new LessOrEqual(exp1, exp2, start)
        } else if(tok.isInstanceOf[GT]) {
          exp1 = new Greater(exp1, exp2, start)
        } else if(tok.isInstanceOf[GTE]) {
          exp1 = new GreaterOrEqual(exp1, exp2, start)
        } else {
          exp1 = new Equal(exp1, exp2, start)
        }
    }

    return exp1
  }

  def parseAddExpression(paramExp1 : Expression = new EmptyExpression(new Position(0))): Expression = {
    val start: Position = getStart()

    var exp1: Expression = if(paramExp1.isInstanceOf[EmptyExpression]){
      parseMultExpression()
    } else {
      paramExp1
    }

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

  def parseMultExpression(paramExp1 : Expression = new EmptyExpression(new Position(0))): Expression = {
    val start: Position = getStart()
    
    var exp1: Expression = if(paramExp1.isInstanceOf[EmptyExpression]){
      parseUnaryExpression()
    } else {
      paramExp1
    }

    while(shouldEat[TIMES]() || shouldEat[DIV]() || shouldEat[DOT]() || shouldEat[DOT]() || shouldEat[IDENT]() || shouldEat[REAL]() || shouldEat[INT]() || shouldEat[LPAR]()){
      val tok: Token = eat()
      if(tok.isInstanceOf[TIMES]){
        val exp2: Expression = parseUnaryExpression()
        exp1 = new Times(exp1, exp2, start)
      } else if(tok.isInstanceOf[DIV]){
        val exp2: Expression = parseUnaryExpression()
        exp1 = new Divide(exp1, exp2, start)
      } else if(tok.isInstanceOf[DOT]) {
        val exp2: Expression = parseUnaryExpression()
        exp1 = new DotProduct(exp1, exp2, start)
      } else if(tok.isInstanceOf[IDENT]){
        val lexeme: String = tok.getLexeme()
        val exp2: Expression = new Identifier(lexeme, start)
        exp1 = new Times(exp1, exp2, start)
      } else if(tok.isInstanceOf[REAL]){
        val lexeme: String = tok.getLexeme()
        val exp2: Expression = new Real(lexeme, start)
        exp1 = new Times(exp1, exp2, start)
      } else if(tok.isInstanceOf[INT]){
        val lexeme: String = tok.getLexeme()
        val exp2: Expression = new Integer(lexeme, start)
        exp1 = new Times(exp1, exp2, start)
      } else {
        val exp2: Expression = parseExpression()
        eatIf[RPAR]()
        exp1 = new Times(exp1, exp2, start)
      }
    }

    return exp1
  }

  def parseUnaryExpression(): Expression = {
    val start: Position = getStart()

    if(eatIfYummy[MINUS]()){
      val exp: Expression = parseUnaryExpression()
      return new Negate(exp, start)
    } else if (eatIfYummy[PLUS]()) {
      return parseUnaryExpression()
    } else if (eatIfYummy[NOT]()) {
      val exp: Expression = parseUnaryExpression()
      return new Not(exp, start)
    } else {
      return parseExponentExpression()
    }
  }

  def parseExponentExpression(paramExp1 : Expression = new EmptyExpression(new Position(0))): Expression = {
    val start: Position = getStart()

    var exp1: Expression = if(paramExp1.isInstanceOf[EmptyExpression]){
      parsePrimaryExpression()
    } else {
      paramExp1
    }

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
      case _ => println("Error: unexpected end of list found when parsing primary expression"); return null
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

    return new FunctionExpression(lexeme, argList.reverse, start)
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