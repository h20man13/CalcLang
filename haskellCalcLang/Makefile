ALL: LEXER PARSER PROGRAM

LEXER:
	alex Lexer.x
PARSER:
	happy -i Parser.y
PROGRAM:
	ghc -o image Lexer.hs Parser.hs Interpreter.hs Main.hs
CLEAN:
	rm -f *.o *.hi *.info Lexer.hs Parser.hs
