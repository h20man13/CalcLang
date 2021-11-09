import scala.collection.mutable.{StringBuilder}

abstract class AstNode(position: Position){
  def getPosition(): Position = position
  override def toString(): String
}

//statement classes
abstract class Statement(position: Position) extends AstNode(position)
case class Assignment(ident: String, expression: Expression, position: Position) extends Statement(position)
case class FunctionDeclaration(lexeme: String, argList: List[String], expression: Expression, position: Position) extends Statement(position){
  override def toString(): String = {
    var sb: StringBuilder = new StringBuilder(lexeme)
    sb ++= "("
     for(i <- 0 until argList.length - 1){
      sb ++= argList(i).toString() + ", "
    }
    sb ++= argList(argList.length - 1) + ")"
    sb ++= " = "
    sb ++= expression.toString()
    return sb.toString()
  }
}
case class PrintExpression(exp: Expression, position: Position) extends Statement(position)

//Expression Classes
abstract class Expression(position: Position) extends AstNode(position)

//Binary Epressions
abstract class Binary(arg1: Expression, arg2: Expression, position: Position) extends Expression(position)
case class Add(arg1: Expression, val arg2: Expression, position: Position) extends Binary(arg1, arg2, position){
  override def toString(): String = arg1.toString() + " + " + arg2.toString()
}
case class Subtract(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position){
  override def toString(): String = arg1.toString() + " - " + arg2.toString()
}
case class Times(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position){
  override def toString(): String = arg1.toString() + " * " + arg2.toString()
}
case class Divide(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position){
  override def toString(): String = arg1.toString() + " / " + arg2.toString()
}
case class Exponent(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position){
  override def toString(): String = arg1.toString() + "^" + arg2.toString()
}

abstract class Unary(arg1: Expression, position: Position) extends Expression(position)

case class Negate(arg1: Expression, position: Position) extends Unary(arg1, position){
  override def toString(): String = "-" + arg1.toString()
}

case class Percent(arg1: Expression, position: Position) extends Unary(arg1, position){
  override def toString(): String = arg1.toString() + "%"
}

case class Dollar(arg1: Expression, position: Position) extends Unary(arg1, position){
  override def toString(): String = "$" + arg1.toString()
}


case class Error(message: String, position: Position) extends Expression(position)
//Other expression values
case class Identifier(lexeme: String, position: Position) extends Expression(position){
  override def toString(): String = lexeme
}
case class Real(value: String, position: Position) extends Expression(position){
  override def toString(): String = value
}
case class Integer(value: String, position: Position) extends Expression(position){
  override def toString(): String = value
}
case class Set(argList: List[Expression], position: Position) extends Expression(position){
  override def toString(): String = {
    var sb: StringBuilder = new StringBuilder("{")
    for(i <- 0 until argList.length - 1){
      sb ++= argList(i).toString() + ", "
    }
    sb ++= argList(argList.length - 1) + "}"
    return sb.toString()
  }
}
case class Tuple(argList: List[Expression], position: Position) extends Expression(position){
  override def toString(): String = {
    var sb: StringBuilder = new StringBuilder("(")
    for(i <- 0 until argList.length - 1){
      sb ++= argList(i).toString() + ", "
    }
    sb ++= argList(argList.length - 1) + ")"
    return sb.toString()
  }
}

case class FunctionExpression(lexeme: String, argList: List[Expression], position: Position) extends Expression(position){
   override def toString(): String = {
    var sb: StringBuilder = new StringBuilder(lexeme)
    sb ++= "("
    for(i <- 0 until argList.length - 1){
      sb ++= argList(i).toString() + ", "
    }
    sb ++= argList(argList.length - 1) + ")"
    return sb.toString()
  }
}
case class ConstantExpression(exp: Expression, position: Position) extends Expression(position) {
  override def toString(): String = exp.toString()
}
case class CompositionExpression(compList: List[String], argList: List[Expression], position: Position) extends Expression(position){
  override def toString(): String = {
    var sb: StringBuilder = new StringBuilder("(")
    for(i <- 0 until compList.length - 1){
      sb ++= compList(i) + " o "
    }
    sb ++= compList(compList.length - 1) + ")("
    for(i <- 0 until argList.length - 1){
      sb ++= argList(i).toString() + ", "
    }
    sb ++= argList(argList.length - 1) + ")"
    return sb.toString()
  }
}