package calclang.passes

import calclang.passes.table._
import calclang.passes.value._
import calclang.parser.ast._
import calclang.passes.util._
import calclang.Position
import scala.collection.mutable.{HashMap, Stack}

object Interpreter {

var variables: Environment[Value] = new Environment(new Stack[HashMap[String, Value]]())
var functions: Environment[FunctionDeclaration] = new Environment(new Stack[HashMap[String, FunctionDeclaration]]())

  variables.addScope()
  functions.addScope()

  def interpret(ast_node: AstNode): Unit = ast_node match {
      case (expNode: Expression) => interpret(expNode)
      case (comNode: Command) => interpret(comNode)
      case (statNode: Statement) => interpret(statNode)
      case a => Passes.errorAndExit("Unknown AstNode command class " + a.toString)
  }

  def interpret(ast_node: Command): Unit = ast_node match {
    case ListVariables(_) => println(variables.toString)
    case ListFunctions(_) => println(functions.toString)
    case DeleteVariables(_) => {variables.removeScope(); variables.addScope()}
    case DeleteFunctions(_) => {functions.removeScope(); functions.addScope()}
    case DeleteVariable(name,_) => variables.removeEntry(name)
    case DeleteFunction(name, _) => functions.removeEntry(name)
    case DeleteCache(_) => println("Deleted Cache")
    case Help(_) => CommandUtil.printHelp()
    case a => Passes.errorAndExit("Unknown AstNode command class " + a.toString)
  }

  def interpret(ast_node: Statement): Unit = ast_node match{
    case PrintExpression(exp, _) => println(interpret(exp).toString())
    case Assignment(ident, expr, _) => { 
      if (variables.entryExists(ident)){
        variables.setEntry(ident, interpret(expr))
      } else {
        variables.addEntry(ident, interpret(expr))
      }
    }
    case FunctionDeclaration(name, params, expr, pos) => {
      if(functions.entryExists(name)){
        functions.setEntry(name, FunctionDeclaration(name, params, expr, pos))
      } else {
        functions.addEntry(name, FunctionDeclaration(name, params, expr, pos))
      }
    }
    case a => Passes.errorAndExit("Unkown statement type when interpreting")
  }

  def interpret(ast_node: Expression): Value = ast_node match{
    case IfExpression(cond, exp1, exp2, _) => OpUtil.ifExpr(interpret(cond), Interpreter.interpret(exp1), Interpreter.interpret(exp2))
    case Add(arg1, arg2, _) => OpUtil.add(interpret(arg1), interpret(arg2))
    case Subtract(arg1, arg2, _) => OpUtil.sub(interpret(arg1), interpret(arg2))
    case Times(arg1, arg2, _) => OpUtil.multiply(interpret(arg1), interpret(arg2))
    case DotProduct(arg1, arg2, _) => OpUtil.dotProduct(interpret(arg1), interpret(arg2))
    case Divide(arg1, arg2, _) => OpUtil.divide(interpret(arg1), interpret(arg2))
    case Exponent(arg1, arg2, _) => OpUtil.exp(interpret(arg1), interpret(arg2))
    case Equal(arg1, arg2, _) => OpUtil.equal(interpret(arg1), interpret(arg2))
    case Greater(arg1, arg2, _) => OpUtil.greater(interpret(arg1), interpret(arg2))
    case Less(arg1, arg2, _) => OpUtil.less(interpret(arg1), interpret(arg2))
    case Negate(arg1, _) => OpUtil.negate(interpret(arg1))
    case Percent(arg1, _) => OpUtil.percent(interpret(arg1))
    case Dollar(arg1,_) => OpUtil.dollar(interpret(arg1)) //figure out this one later
    case Set(elemList, _) => SetValue(elemList.map(elem => interpret(elem)))
    case Tuple(elemList, _) => TupleValue(elemList.map(elem => interpret(elem)))
    case ConstantExpression(expr, _) => interpret(expr)
    case FunctionExpression(name, exprList, _) => {
      if(functions.entryExists(name)){
        val entry: FunctionDeclaration = functions.getEntry(name)
        entry match{
          case FunctionDeclaration(_, params, expr, _) => {
            variables.addScope()
            for(i <- 0 until params.length){
              if(variables.inScope(params(i))){
                Passes.errorAndExit("Duplicate paramater " + params(i) + " declared in function " + name + "\n" + entry.toString())
              } else {
                variables.addEntry(params(i), interpret(exprList(i)))
              }
            }
            val result: Value = interpret(expr)
            variables.removeScope()
            result
          }
          case _ => sys.error("Unreachable")
        }
      } else {
        Passes.errorAndExit("Error: function with name " + name + "doesnt exist")
      }
    }
    case CompositionExpression(compList, argList, pos) => {
      var resVal: Value = new IntValue(0)
      var res: List[Expression] = argList
      for(comp <- compList){
        val funcExpr: FunctionExpression = new FunctionExpression(comp, res, pos)
        resVal = interpret(funcExpr)
        res = Passes.valueToExpression(resVal, pos) :: Nil
      }
      resVal
    } 
    case Identifier(name, _) => variables.getEntry(name)
    case Integer(arg1, _) => IntValue(arg1.toInt)
    case Real(arg1, _) => RealValue(arg1.toDouble)
    case _ => Passes.errorAndExit("Unknown expression node of type " + ast_node.getClass.getSimpleName); null
  }
}
