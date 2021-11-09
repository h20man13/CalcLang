trait Value {
  def toString(): String
}

case class IntValue(value: Int) extends Value {
  override def toString(): String = value.toString
}
case class RealValue(value: Double) extends Value {
  override def toString(): String = value.toString
}
case class SetValue(values: List[Value]) extends Value {
  override def toString(): String = {
    var output: StringBuilder = new StringBuilder()
    output += '{'
    if(!(values.isEmpty)){
      var i = 0
      for(i <- 0 until (values.length - 1)){
        output ++= values(i).toString()
        output += ','
      }
      output ++= values(values.length - 1).toString()
    }
    output += '}'
    return output.toString
  }
}
case class TupleValue(values: List[Value]) extends Value {
  override def toString(): String = {
    var output: StringBuilder = new StringBuilder()
    output += '('
    if(!(values.isEmpty)){
      var i: Int = 0
      for(i <- 0 until (values.length - 1)){
        output ++= values(i).toString()
        output += ','
      }
      output ++= values(values.length - 1).toString()
    }
    output += ')'
    return output.toString
  }
}
case class DollarValue(value: Double) extends Value {
  override def toString(): String = ("$%.2f").format(value)
}
case class PercentValue(value: Double) extends Value {
  override def toString(): String = ("%.2f").format(value * 100) + '%'
}
