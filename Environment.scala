import scala.collection.mutable.{HashMap, Stack, StringBuilder}

class Environment[EntryType](symbolTable: Stack[HashMap[String, EntryType]]){

  def entryExists(value: String): Boolean = {
    for(scope <- symbolTable){
      for((key, _) <- scope){
        if(key == value) return true
      }
    }
    return false
  }

  def addScope(): Unit = symbolTable.push(new HashMap[String, EntryType]())
  
  def removeScope(): Unit = symbolTable.pop()
  def inScope(value: String): Boolean = {
    for((key, _) <- symbolTable.top){
      if (key == value) return true
    }
    return false
  }

  def getEntry(value: String): EntryType = {
    for (scope <- symbolTable){
      for((key, entry) <- scope){
        if(key == value) return entry
      }
    }
    sys.error("Error: Entry " + value + " not found ")
  }

  def addEntry(key: String, entry: EntryType): Unit = symbolTable.top.put(key, entry)

  def removeEntry(key: String): Unit = symbolTable.top.remove(key)

  def setEntry(key: String, entry: EntryType) = symbolTable.top(key) = entry
  
  def padLeft(str: String, spaces: Int): String = {
    var sb: StringBuilder = new StringBuilder(str)
    var amount: Int = spaces - str.length
    while(amount > 0){
      sb += ' '
      amount = amount - 1
    }
    return sb.toString()
  }

  override def toString(): String = {
    var sb: StringBuilder = new StringBuilder()
    sb ++= "---------------------------------------------\n"
    sb ++= "| Key                 | Value               |\n"
    sb ++= "---------------------------------------------\n"
    for (scope <- symbolTable){
      for((key, entry) <- scope){
        sb ++= "|" + padLeft(key, 21) + "|" + padLeft(entry.toString(), 21) + "|\n"
        sb ++= "---------------------------------------------\n"
      }
    }
    return sb.toString()
  }
}