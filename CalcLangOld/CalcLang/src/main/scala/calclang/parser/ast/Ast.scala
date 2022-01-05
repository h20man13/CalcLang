package calclang.parser.ast

import calclang.Position
import calclang.passes.Passes

import scala.collection.mutable.{StringBuilder}

abstract class AstNode(position: Position){
  def getPosition(): Position = position
  override def toString(): String = Passes.toString(this)
}

//commands are listed below
abstract class Command(position: Position) extends Statement(position)
case class EmptyCommand(position: Position) extends Command(position)
case class ListVariables(position: Position) extends Command(position)
case class ListFunctions(position: Position) extends Command(position)
case class DeleteVariable(name: String, position: Position) extends Command(position)
case class DeleteFunction(name: String, position: Position) extends Command(position)
case class DeleteVariables(position: Position) extends Command(position)
case class DeleteFunctions(position: Position) extends Command(position)
case class DeleteCache(position: Position) extends Command(position)
case class Help(position: Position) extends Command(position)

//statement classes
abstract class Statement(position: Position) extends AstNode(position)
case class EmptyStatement(position: Position) extends Statement(position)
case class Assignment(ident: String, expression: Expression, position: Position) extends Statement(position)
case class FunctionDeclaration(lexeme: String, argList: List[String], expression: Expression, position: Position) extends Statement(position)
case class PrintExpression(exp: Expression, position: Position) extends Statement(position)

//Expression Classes
abstract class Expression(position: Position) extends AstNode(position)
case class EmptyExpression(position: Position) extends Expression(position)

//If Expression
case class IfExpression(cond: Expression, ifTrue: Expression, ifFalse: Expression, position: Position) extends Expression(position)

//Binary Epressions
abstract class Binary(arg1: Expression, arg2: Expression, position: Position) extends Expression(position)
case class And(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position)
case class Or(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position)
case class Add(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position)
case class Subtract(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position)
case class Times(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position)
case class DotProduct(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position)
case class Divide(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position)
case class Exponent(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position)
case class Less(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position)
case class Greater(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position)
case class LessOrEqual(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position)
case class GreaterOrEqual(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position)
case class Equal(arg1: Expression, arg2: Expression, position: Position) extends Binary(arg1, arg2, position)


abstract class Unary(arg1: Expression, position: Position) extends Expression(position)
case class Negate(arg1: Expression, position: Position) extends Unary(arg1, position)
case class Not(arg1: Expression, position: Position) extends Unary(arg1, position)
case class Percent(arg1: Expression, position: Position) extends Unary(arg1, position)
case class Dollar(arg1: Expression, position: Position) extends Unary(arg1, position)

//Other expression values
case class Identifier(lexeme: String, position: Position) extends Expression(position)
case class Real(value: String, position: Position) extends Expression(position)
case class Integer(value: String, position: Position) extends Expression(position)
case class Set(argList: List[Expression], position: Position) extends Expression(position)
case class Tuple(argList: List[Expression], position: Position) extends Expression(position)
case class FunctionExpression(lexeme: String, argList: List[Expression], position: Position) extends Expression(position)
case class ConstantExpression(exp: Expression, position: Position) extends Expression(position)
case class CompositionExpression(compList: List[String], argList: List[Expression], position: Position) extends Expression(position)