package calclang.passes

import calclang.passes.table._
import calclang.passes.value._
import calclang.parser.ast._
import calclang.passes.util._
import calclang.Position

import scala.collection.mutable.{HashMap, Stack}

object Passes {

  def errorAndExit(message: String) = {
    println(message)
    sys.exit()
  }

  

  def valueToExpression(value: Value, pos: Position): Expression = {
    value match {
      case IntValue(value) => new Integer(value.toString, pos)
      case RealValue(value) => new Real(value.toString, pos)
      case TupleValue(valueList) => new Tuple(valueList.map(x => valueToExpression(x, pos)), pos)
      case SetValue(valueList) => new Set(valueList.map(x => valueToExpression(x, pos)), pos)
      case PercentValue(value) => new Percent(new Real(value.toString, pos), pos)
      case DollarValue(value) => new Dollar(new Real(value.toString, pos), pos)
      case _ => errorAndExit("Unknon case class found")
    }
  }

  //To String functions 
  def toString(node: AstNode): String = node match {
    case Integer(lexeme, _) => lexeme
    case Real(lexeme, _) => lexeme
    case Identifier(lexeme, _) => lexeme
    case Tuple(exps, _) =>  "(" + stringOfList(exps) + ")"
    case Set(exps, _) => "{" + stringOfList(exps) + "}"
    case Dollar(arg1, _) => "$" + arg1.toString
    case Percent(arg1, _) => arg1.toString + "%"
  }

  def stringOfList(expList: List[Expression]): String = {
    var lengthOfExpList: Int = expList.length
    var sb: StringBuilder = new StringBuilder()
    if(lengthOfExpList > 0){
      var i: Int = 0
      while(i < lengthOfExpList - 1){
        sb ++= expList(i).toString
        sb ++= ", "
        i = i + 1
      }
      sb ++= expList(i).toString
    }
    sb.toString
  }
}