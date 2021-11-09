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
case class GT(position: Position) extends Reserved(position)
case class EXP(position: Position) extends Reserved(position)
case class DOLLAR(position: Position) extends Reserved(position)
case class OF(position: Position) extends Reserved(position)


abstract class Misc(lexeme: String, position: Position) extends Token(position){
  override def toString(): String = "Token " + this.getClass.getSimpleName + " ( " + lexeme + " ) at " + position.toString()
  def getLexeme(): String = lexeme
}

//Other Tokens
case class IDENT(lexeme: String, position: Position) extends Misc(lexeme, position)
case class REAL(lexeme: String, position: Position) extends Misc(lexeme, position)
case class INT(lexeme: String, position: Position) extends Misc(lexeme, position)

