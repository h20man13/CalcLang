package calclang

import calclang.io._
import calclang.lexer._
import calclang.parser._
import calclang.passes._
import calclang.parser.ast._
import calclang.lexer.token._
import calclang.passes.context.Context

import java.io.StringReader
import scala.io.StdIn.readLine

object App {
  def main(args: Array[String]): Unit = {
    println("Welcome to calc lang. Make sure to type in :Help for information about how to use the language")
    while(Context.shouldContinue){
      val line: String = readLine(Context.promptSymbol + " ")
      var source : Source = new Source(new StringReader(line));
      var lexer: Lexer = new Lexer(source)
      var toks: List[Token] = lexer.genTokens()
      var pser: Parser = new Parser(toks)
      val lineAst: AstNode = pser.parseLine()
      Interpreter.interpret(lineAst)
    }
  }
}
