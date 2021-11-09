object OpUtil{

  def add(arg1: Value, arg2: Value): Value = (arg1, arg2) match {
      case (IntValue(arg1), IntValue(arg2)) => IntValue(arg1 + arg2)
      case (IntValue(arg1), RealValue(arg2)) => RealValue(arg1 + arg2)
      case (RealValue(arg1), RealValue(arg2)) => RealValue(arg1 + arg2)
      case (RealValue(arg1), IntValue(arg2)) => RealValue(arg1 + arg2)
      case (DollarValue(arg1), DollarValue(arg2)) => DollarValue(arg1 + arg2)
      case (PercentValue(arg1), PercentValue(arg2)) => PercentValue(arg1 + arg2)
      case (SetValue(argList1), SetValue(argList2)) => SetValue((argList1, argList2).zipped.map(add(_,_)))
      case (SetValue(argList1), TupleValue(argList2)) => SetValue((argList1, argList2).zipped.map(add(_,_)))
      case (TupleValue(argList1), SetValue(argList2)) => TupleValue((argList1, argList2).zipped.map(add(_,_)))
      case (TupleValue(argList1), TupleValue(argList2)) => TupleValue((argList1, argList2).zipped.map(add(_,_)))
      case (SetValue(argList1), arg2) => SetValue(argList1.map(x => add(x, arg2)))
      case (TupleValue(argList1), arg2) => TupleValue(argList1.map(x => add(x, arg2)))
      case (arg1, SetValue(argList2)) => SetValue(argList2.map(x => add(arg1, x)))
      case (arg1, TupleValue(argList2)) => TupleValue(argList2.map(x => add(arg1, x)))
      case (x, y) => sys.error("Cannot add " + x.getClass.getSimpleName + " by " + x.getClass.getSimpleName); null
  }

  def sub(arg1: Value, arg2: Value): Value = (arg1, arg2) match {
      case (IntValue(arg1), IntValue(arg2)) => IntValue(arg1 - arg2)
      case (IntValue(arg1), RealValue(arg2)) => RealValue(arg1 - arg2)
      case (RealValue(arg1), RealValue(arg2)) => RealValue(arg1 - arg2)
      case (RealValue(arg1), IntValue(arg2)) => RealValue(arg1 - arg2)
      case (DollarValue(arg1), DollarValue(arg2)) => DollarValue(arg1 - arg2)
      case (PercentValue(arg1), PercentValue(arg2)) => PercentValue(arg1 - arg2)
      case (SetValue(argList1), SetValue(argList2)) => SetValue((argList1, argList2).zipped.map(sub(_, _)))
      case (SetValue(argList1), TupleValue(argList2)) => SetValue((argList1, argList2).zipped.map(sub(_,_)))
      case (TupleValue(argList1), SetValue(argList2)) => TupleValue((argList1, argList2).zipped.map(sub(_,_)))
      case (TupleValue(argList1), TupleValue(argList2)) => TupleValue((argList1, argList2).zipped.map(sub(_,_)))
      case (SetValue(argList1), arg2) => SetValue(argList1.map(x => sub(x, arg2)))
      case (TupleValue(argList1), arg2) => TupleValue(argList1.map(x => sub(x, arg2)))
      case (arg1, SetValue(argList2)) => SetValue(argList2.map(x => sub(arg1, x)))
      case (arg1, TupleValue(argList2)) => TupleValue(argList2.map(x => sub(arg1, x)))
      case (x, y) => sys.error("Cannot multiply " + x.getClass.getSimpleName + " by " + x.getClass.getSimpleName); null
  }
  

  def multiply(arg1: Value, arg2: Value): Value = (arg1, arg2) match {
      case (IntValue(arg1), IntValue(arg2)) => IntValue(arg1 * arg2)
      case (IntValue(arg1), PercentValue(arg2)) => PercentValue(arg1 * arg2)
      case (IntValue(arg1), DollarValue(arg2)) => DollarValue(arg1 * arg2)
      case (IntValue(arg1), RealValue(arg2)) => RealValue(arg1 * arg2)
      case (RealValue(arg1), RealValue(arg2)) => RealValue(arg1 * arg2)
      case (RealValue(arg1), IntValue(arg2)) => RealValue(arg1 * arg2)
      case (RealValue(arg1), PercentValue(arg2)) => PercentValue(arg1 * arg2)
      case (RealValue(arg1), DollarValue(arg2)) => DollarValue(arg1 * arg2)
      case (SetValue(argList1), SetValue(argList2)) => SetValue((argList1, argList2).zipped.map(multiply(_, _)))
      case (SetValue(argList1), TupleValue(argList2)) => SetValue((argList1, argList2).zipped.map(multiply(_,_)))
      case (TupleValue(argList1), SetValue(argList2)) => TupleValue((argList1, argList2).zipped.map(multiply(_,_)))
      case (TupleValue(argList1), TupleValue(argList2)) => TupleValue((argList1, argList2).zipped.map(multiply(_,_)))
      case (SetValue(argList1), arg2) => SetValue(argList1.map(x => multiply(x, arg2)))
      case (TupleValue(argList1), arg2) => TupleValue(argList1.map(x => multiply(x, arg2)))
      case (arg1, SetValue(argList2)) => SetValue(argList2.map(x => multiply(arg1, x)))
      case (arg1, TupleValue(argList2)) => TupleValue(argList2.map(x => multiply(arg1, x)))
      case (DollarValue(arg1), PercentValue(arg2)) => DollarValue(arg1 * arg2)
      case (DollarValue(arg1), IntValue(arg2)) => DollarValue(arg1 * arg2)
      case (DollarValue(arg1), RealValue(arg2)) => DollarValue(arg1 * arg2)
      case (PercentValue(arg1), PercentValue(arg2)) => PercentValue(arg1 * arg2)
      case (PercentValue(arg1), IntValue(arg2)) => PercentValue(arg1 * arg2)
      case (PercentValue(arg1), RealValue(arg2)) => PercentValue(arg1 * arg2)
      case (x, y) => sys.error("Cannot multiply " + x.getClass.getSimpleName + " by " + x.getClass.getSimpleName); null
  }

  def divide(arg1: Value, arg2: Value): Value = (arg1, arg2) match {
      case (IntValue(arg1), IntValue(arg2)) => RealValue(arg1 / arg2)
      case (IntValue(arg1), PercentValue(arg2)) => RealValue(arg1 / arg2)
      case (IntValue(arg1), RealValue(arg2)) => RealValue(arg1 / arg2)
      case (RealValue(arg1), RealValue(arg2)) => RealValue(arg1 / arg2)
      case (RealValue(arg1), IntValue(arg2)) => RealValue(arg1 / arg2)
      case (RealValue(arg1), PercentValue(arg2)) => RealValue(arg1 / arg2)
      case (SetValue(argList1), SetValue(argList2)) => SetValue((argList1, argList2).zipped.map(divide(_, _)))
      case (SetValue(argList1), TupleValue(argList2)) => SetValue((argList1, argList2).zipped.map(divide(_,_)))
      case (TupleValue(argList1), SetValue(argList2)) => TupleValue((argList1, argList2).zipped.map(divide(_,_)))
      case (TupleValue(argList1), TupleValue(argList2)) => TupleValue((argList1, argList2).zipped.map(divide(_,_)))
      case (SetValue(argList1), arg2) => SetValue(argList1.map(x => divide(x, arg2)))
      case (TupleValue(argList1), arg2) => TupleValue(argList1.map(x => divide(x, arg2)))
      case (arg1, SetValue(argList2)) => SetValue(argList2.map(x => divide(arg1, x)))
      case (arg1, TupleValue(argList2)) => TupleValue(argList2.map(x => divide(arg1, x)))
      case (DollarValue(arg1), DollarValue(arg2)) => RealValue(arg1 / arg2)
      case (DollarValue(arg1), PercentValue(arg2)) => DollarValue(arg1 / arg2)
      case (DollarValue(arg1), IntValue(arg2)) => DollarValue(arg1 / arg2)
      case (DollarValue(arg1), RealValue(arg2)) => DollarValue(arg1 / arg2)
      case (PercentValue(arg1), PercentValue(arg2)) => RealValue(arg1 / arg2)
      case (PercentValue(arg1), IntValue(arg2)) => PercentValue(arg1 / arg2)
      case (PercentValue(arg1), RealValue(arg2)) => PercentValue(arg1 / arg2)
      case (x, y) => sys.error("Cannot divide " + x.getClass.getSimpleName + " by " + x.getClass.getSimpleName); null
  }

  def exp(arg1: Value, arg2: Value): Value = (arg1, arg2) match {
      case (IntValue(arg1), IntValue(arg2)) => IntValue((scala.math.pow(arg1,arg2).toInt))
      case (IntValue(arg1), PercentValue(arg2)) => RealValue(scala.math.pow(arg1,arg2))
      case (IntValue(arg1), RealValue(arg2)) => RealValue(scala.math.pow(arg1,arg2))
      case (RealValue(arg1), RealValue(arg2)) => RealValue(scala.math.pow(arg1,arg2))
      case (RealValue(arg1), IntValue(arg2)) => RealValue(scala.math.pow(arg1,arg2))
      case (SetValue(argList1), SetValue(argList2)) => SetValue((argList1, argList2).zipped.map(exp(_,_)))
      case (SetValue(argList1), TupleValue(argList2)) => SetValue((argList1, argList2).zipped.map(exp(_,_)))
      case (TupleValue(argList1), SetValue(argList2)) => TupleValue((argList1, argList2).zipped.map(exp(_,_)))
      case (TupleValue(argList1), TupleValue(argList2)) => TupleValue((argList1, argList2).zipped.map(exp(_,_)))
      case (SetValue(argList1), arg2) => SetValue(argList1.map(x => exp(x, arg2)))
      case (TupleValue(argList1), arg2) => TupleValue(argList1.map(x => exp(x, arg2)))
      case (arg1, SetValue(argList2)) => SetValue(argList2.map(x => exp(arg1, x)))
      case (arg1, TupleValue(argList2)) => TupleValue(argList2.map(x => exp(arg1, x)))
      case (DollarValue(arg1), IntValue(arg2)) => DollarValue(scala.math.pow(arg1,arg2))
      case (DollarValue(arg1), RealValue(arg2)) => DollarValue(scala.math.pow(arg1,arg2))
      case (PercentValue(arg1), IntValue(arg2)) => PercentValue(scala.math.pow(arg1,arg2))
      case (PercentValue(arg1), RealValue(arg2)) => PercentValue(scala.math.pow(arg1,arg2))
      case (x, y) => sys.error("Cannot divide " + x.getClass.getSimpleName + " by " + x.getClass.getSimpleName); null
  }
    
  def negate(arg1: Value): Value = arg1 match {
      case IntValue(arg1) => IntValue(-arg1)
      case RealValue(arg1) => RealValue(-arg1)
      case DollarValue(arg1) => DollarValue(-arg1)
      case PercentValue(arg1) => PercentValue(-arg1)
      case SetValue(argList1) => SetValue(argList1.map(x => negate(x)))
      case TupleValue(argList1) => TupleValue(argList1.map(x => negate(x)))
      case x => sys.error("Unexpected type " + x.getClass.getSimpleName + " for negation"); null
  }

  def percent(arg1: Value): PercentValue = arg1 match {
    case IntValue(arg1) => PercentValue(arg1/100)
    case RealValue(arg1) => PercentValue(arg1/100)
    case x => sys.error("Unexpected type " + x.getClass.getSimpleName + " for percent expression"); null
  }

  def dollar(arg1: Value): DollarValue = arg1 match {
    case IntValue(arg1) => DollarValue(arg1)
    case RealValue(arg1) => DollarValue(arg1)
    case x => sys.error("Unexpected type " + x.getClass.getSimpleName + " for dollar expression"); null
  }

}