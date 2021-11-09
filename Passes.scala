import scala.collection.mutable.{HashMap, Stack}

object Passes {

  var variables: Environment[Value] = new Environment(new Stack[HashMap[String, Value]]())
  var functions: Environment[FunctionDeclaration] = new Environment(new Stack[HashMap[String, FunctionDeclaration]]())

  variables.addScope()
  functions.addScope()

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
    case _ => None
  }

  def interpret(ast_node: Expression): Value = ast_node match{
    case Add(arg1, arg2, _) => OpUtil.add(interpret(arg1), interpret(arg2))
    case Subtract(arg1, arg2, _) => OpUtil.sub(interpret(arg1), interpret(arg2))
    case Times(arg1, arg2, _) => OpUtil.multiply(interpret(arg1), interpret(arg2))
    case Divide(arg1, arg2, _) => OpUtil.divide(interpret(arg1), interpret(arg2))
    case Exponent(arg1, arg2, _) => OpUtil.exp(interpret(arg1), interpret(arg2))
    case Negate(arg1, _) => OpUtil.negate(interpret(arg1))
    case Percent(arg1, _) => OpUtil.percent(interpret(arg1))
    case Dollar(arg1,_) => OpUtil.dollar(interpret(arg1)) //figure out this one later
    case Set(elemList, _) => SetValue(elemList.map(elem => interpret(elem)))
    case Tuple(elemList, _) => TupleValue(elemList.map(elem => interpret(elem)))
    case ConstantExpression(expr, _) => interpret(expr)
    case Identifier(name, _) => variables.getEntry(name)
    case Integer(arg1, _) => IntValue(arg1.toInt)
    case Real(arg1, _) => RealValue(arg1.toDouble)
    case _ => sys.error("Unknown expression node of type " + ast_node.getClass.getSimpleName); null
  }
}