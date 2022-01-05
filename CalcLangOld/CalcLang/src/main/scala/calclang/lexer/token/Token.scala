package calclang.lexer.token

import calclang.Position

abstract class Token(position: Position){
  def toString(): String
  def getLexeme(): String
  def getPosition(): Position = position
}

case class ERROR(message: String, position: Position) extends Token(position) {
  override def toString(): String = "Error at " + position.toString() + '\n' + message
  def getLexeme(): String = toString()
}
//class to generate reserved tokens
abstract class Reserved(position: Position) extends Token(position){
  override def toString(): String = "Token " + this.getClass.getSimpleName + " at " + position.toString()
  def getLexeme(): String = this.getClass.getSimpleName
}

//Reserved Tokens
case class LPAR(position: Position) extends Reserved(position)
case class RPAR(position: Position) extends Reserved(position)
case class LCURL(position: Position) extends Reserved(position)
case class RCURL(position: Position) extends Reserved(position)
case class EQ(position: Position) extends Reserved(position)
case class PLUS(position: Position) extends Reserved(position)
case class MINUS(position: Position) extends Reserved(position)
case class TIMES(position: Position) extends Reserved(position)
case class DIV(position: Position) extends Reserved(position)
case class COMMA(position: Position) extends Reserved(position)
case class PERCENT(position: Position) extends Reserved(position)
case class LT(position: Position) extends Reserved(position)
case class LTE(position: Position) extends Reserved(position)
case class GTE(position: Position) extends Reserved(position)
case class GT(position: Position) extends Reserved(position)
case class EXP(position: Position) extends Reserved(position)
case class DOLLAR(position: Position) extends Reserved(position)
case class OF(position: Position) extends Reserved(position)
case class COLON(position: Position) extends Reserved(position)
case class DOT(position: Position) extends Reserved(position)
case class IS(position: Position) extends Reserved(position)
case class NOT(position: Position) extends Reserved(position)
case class AND(position: Position) extends Reserved(position)
case class OR(position: Position) extends Reserved(position)
case class IF(position: Position) extends Reserved(position)
case class THEN(position: Position) extends Reserved(position)
case class ELSE(position: Position) extends Reserved(position)



abstract class Misc(lexeme: String, position: Position) extends Token(position){
  override def toString(): String = "Token " + this.getClass.getSimpleName + " ( " + lexeme + " ) at " + position.toString()
  def getLexeme(): String = lexeme
}

object TokUtil{
  def makeIdentToken(lexeme: String, position: Position): Token = lexeme match {
    case "if" => IF(position)
    case "or" => OR(position)
    case "then" => THEN(position)
    case "else" => ELSE(position)
    case "and" => AND(position)
    case "not" => NOT(position)
    case "is" => IS(position)
    case _ => IDENT(lexeme, position)
  }

  def makeOpToken(lexeme: String, start: Position): Token = lexeme match {
        case "(" => new LPAR(start)
        case ")" => new RPAR(start)
        case "{" => new LCURL(start)
        case "}" => new RCURL(start)
        case "+" => new PLUS(start)
        case "<" => new LT(start)
        case "<=" => new LTE(start)
        case ">" => new GT(start)
        case ">=" => new GTE(start)
        case "-" => new MINUS(start)
        case "*" => new TIMES(start)
        case "/" => new DIV(start)
        case "%" => new PERCENT(start)
        case "$" => new DOLLAR(start)
        case "o" => new OF(start)
        case "," => new COMMA(start)
        case "=" => new IS(start)
        case "==" => new EQ(start)
        case "^" => new EXP(start)
        case "." => new DOT(start)
        case ":" => new COLON(start)
        case _ => new ERROR("Invalid reserved token found " + lexeme, start)
  }

  def isOpToken(lexeme: String): Boolean = lexeme match {
    case "(" => true
    case ")" => true
    case "{" => true
    case "}" => true
    case "+" => true
    case "<" => true
    case "<=" => true
    case ">" => true
    case ">=" => true
    case "-" => true
    case "*" => true
    case "/" => true
    case "%" => true
    case "$" => true
    case "o" => true
    case "," => true
    case "=" => true
    case "==" => true
    case "^" => true
    case "." => true
    case ":" => true
    case _ => false
  }
}

//Other Tokens
case class IDENT(lexeme: String, position: Position) extends Misc(lexeme, position)
case class REAL(lexeme: String, position: Position) extends Misc(lexeme, position)
case class INT(lexeme: String, position: Position) extends Misc(lexeme, position)

