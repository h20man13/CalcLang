package calclang.passes.util

object CommandUtil {
  def printHelp(): Unit = {
    println("Welcome to Calclang a language created by Mr. Bauer in order to play around with functions")
    println("Commands are prefixed with a colon(:) and begin with a capital letter in CalcLang. A full list of commands is below:")
    printHeader("Command List")
    printCommand("Quit", "Exits the program")
    printCommand("Enviro", "Lists all declared variables and functions since the start of the session")
    printCommand("Variables", "Lists all declared variables and since the start of the session")
    printCommand("Functions", "Lists all declared functions since the start of the session")
    printCommand("Prompt","Sets the prompt symbol before you begin typing to something else")
    printHeader("Identifiers")
    println("\tAll identifiers (Variable Names, Function Names) must begin with anyletter that isnt a lowercase o and they must only contain letters in their name")
    printHeader("Constants")
    println("\tSets: {1,4,6}, {5, 9, 8, 0, 1}, etc...")
    println("\tTuples: (8,1,4), (2,4) - Must have two or more elements")
    println("\tNumbers: Base-10 numbers only. Can be positive or negative and with floating point values")
    println("\tPercents: 10%, 100%, 1000%. In operations these appear as .10, 1.00 and 10.00 respectively")
    println("\tDollar Amounts: $10, $100, $1000")
    printHeader("Expressions")
    println("\tTyping in an expression will print out the result on the line below it")
    println("\t(Ex: Typing in 3 + 2 will print out 5 on the line below it)")
    println("\t(Ex: Typing in f(1) will yeild the result of f(1))")
    println("\t(Ex: Typing in (f o g)(1) will yeild the result of f(g(1))")
    println("\t(Ex: Typing in f({3, 4, 5}) or f((4, 5, 6)) will apply the function to every element in the set or tuple)")
    println("\t(Ex: Typing in 40 + (3, 6, 7) will yeild a tuple (43, 46, 47)")
    println("\t(Ex: Typing in {2, 4, 6} / 2 will yeild a set {1,2,3}")
    printHeader("Variable Declarations/Assignments")
    println("\tVariables are declared in the usual fassion. They do not have return types assosciated with them at run time. Therefor variables types can change via assignments") 
    println("\tThe grammar for variable assignments is the following <Name> = <Expression>")
    println("\tWhere the name of the variable can not start with a lowercase o like stated above")
    printHeader("Function Declarations")
    println("\tFunctions are declared in the usual fassion. They allways return a result in CalcLang.") 
    println("\tThe grammer for functions is the following <Name> ( <Paramater List> ) = <Expression>")
    println("\tWhere the name of the function can not start with a lowercase o like stated above and Paramaters are seperated by commas")
    printHeader("")
  }

  def printHeader(input: String): Unit = {
    println("")
    println(input)
    println("---------------------------------------------------------------------")
  }

  def printCommand(name: String, description: String): Unit = {
    println("\t" + name + "(:" + name + ") " + description)
  }
}
