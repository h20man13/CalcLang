class Lexer(val source: Source){
  
  def genTokens() : List[Token] = {
    var token_list: List[Token] = List[Token]()
    
    while(!source.empty()){
      val tok: Token = genToken()
      if(!tok.isInstanceOf[ERROR]){
        token_list = tok :: token_list
      } else {
        
      }
    }

    return token_list.reverse
  }

  def genReserved(current: Char) : Token = {
    val start = source.getPosition()
    source.advance()
    current match{
      case '(' => new LPAR(start)
      case ')' => new RPAR(start)
      case '{' => new LCURL(start)
      case '}' => new RCURL(start)
      case '+' => new PLUS(start)
      case '-' => new MINUS(start)
      case '*' => new TIMES(start)
      case '/' => new DIV(start)
      case '%' => new PERCENT(start)
      case '$' => new DOLLAR(start)
      case 'o' => new OF(start)
      case ',' => new COMMA(start)
      case '=' => new EQ(start)
      case '^' => new EXP(start)
      case _ => new ERROR("Invalid reserved token found " + current, start)
    }
  }

  def isReserved(value: Char): Boolean = value match{
    case '{' | '}' | '=' | '(' | ')' | '+' | '-' | '*' | '/' | '%' | '$' | 'o' | ',' | '^' | '=' => true
    case _ => false
  }

  def skipWhitespace(): Unit = {
    while(source.getCurrent().isWhitespace){
      source.advance()
    }
  }

  def skipNonSpace(): Unit = {
    while(!(source.getCurrent().isWhitespace)){
      source.advance()
    }
  }

  def genError(message: String): Token = {
    val error = new ERROR(message, source.getPosition());
    skipNonSpace()
    error
  }

  def genInteger(): Token = {
    var lexeme: StringBuilder = new StringBuilder()
    val start: Position = source.getPosition()
    var current: Char = source.getCurrent()
    
    while(current.isDigit || current == '.'){
      lexeme.append(current)
      source.advance()
      if(current == '.'){
        return genReal(lexeme)
      }
      current = source.getCurrent()
    }

    return new INT(lexeme.toString(), start)
  }

  def genReal(lexeme: StringBuilder): Token = {
    val start: Position = source.getPosition()
    var current: Char = source.getCurrent()
    while(current.isDigit){
      lexeme.append(current)
      source.advance()
      current = source.getCurrent()
    }

    return new REAL(lexeme.toString(), start)
  }

  def genIdentifier(): Token = {
    var lexeme: StringBuilder = new StringBuilder()
    val start: Position = source.getPosition()
    var current: Char = source.getCurrent()
    while(current.isLetter || current.isDigit){
      lexeme.append(current)
      source.advance()
      current = source.getCurrent()
    }

    return new IDENT(lexeme.toString(), start)
  }

  def genToken() : Token = {
    val current : Char = source.getCurrent()
    current match{
      case value if value.isWhitespace => {skipWhitespace(); genToken()}
      case value if isReserved(value) => genReserved(value)
      case value if value.isLetter => genIdentifier()
      case value if value.isDigit => genInteger()
      case '.' => source.advance(); genReal(new StringBuilder('.'))
      case _ => genError("Unexpected token found " + current)
    }
  }
}
