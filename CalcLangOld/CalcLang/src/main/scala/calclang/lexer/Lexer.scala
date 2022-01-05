package calclang.lexer

import calclang.lexer.token._
import calclang.Position
import calclang.io.Source

class Lexer(val source: Source){
  
  def genTokens() : List[Token] = {
    var token_list: List[Token] = List[Token]()
    
    while(!source.empty()){
      val tok: Token = genToken()
      token_list = tok :: token_list
    }

    return token_list.reverse
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

    return TokUtil.makeIdentToken(lexeme.toString(), start)
  }

  def genOp(): Token = {
     val start: Position = source.getPosition()
     val current : Char = source.getCurrent()
     val next: Char = source.getNext()

    if((current == '>' || current == '<' || current == '=') && next == '='){
      source.advance(2)
      return  TokUtil.makeOpToken( "" + current + next, start)
    } else {
      source.advance()
      TokUtil.makeOpToken(current.toString, start)
    }
  }

  def genToken() : Token = {
    val current : Char = source.getCurrent()
    val start: Position = source.getPosition()
    current match{
      case 'o' if source.getNext().isWhitespace => genOp()
      case value if value.isWhitespace => {skipWhitespace(); genToken()}
      case value if TokUtil.isOpToken(value.toString) => genOp()
      case value if value.isLetter => genIdentifier()
      case value if value.isDigit => genInteger()
      case '.' => source.advance(); genReal(new StringBuilder('.'))
      case _ => genError("Unexpected token found " + current)
    }
  }
}
