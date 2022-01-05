{
module Lexer(Token(..), genTokens) where
}

%wrapper "basic"

$special	=[\,\(\)\{\}\%\$]
$decimal	=[\.]
$letter		=[a-zA-Z]
$newline	=[\n]
$whitespace	=[\t\r\v\f\ ]
$digit		=[0-9]

@operator 	= "="|"=="|"!="|"<"|">"|"<="|">="|"."|"+"|"-"|"*"|"/"|"^"
@real 		= $digit+ $decimal $digit*
@integer 	= $digit+
@identifier     = $letter+

tokens :-
       <0> $whitespace+ ;
       <0> @real { mkRealTok }
       <0> @integer { mkIntTok }
       <0> @identifier { mkIdentTok }
       <0> @operator { mkOperatorTok }
       <0> $special { mkSpecialTok }
       <0> $newline { mkNewLineTok }
{
data Token
     =	IDENT String
     | 	INTEGER String
     |  REAL String
     |  FOR
     | 	OF
     |	ELSE
     |	EQUALS
     |	IS
     |  FUNC
     |	AND
     |	OR
     |	NOT
     |	POSITIVE
     |	NEGATIVE
     |	ASTRIX
     | 	SLASH
     | 	PERCENT
     |	DOLLAR
     |	LCURL
     |	RCURL
     |  COMMA
     |	RPAR
     | 	LPAR
     |	DOT
     |  CARROT
     |  LTAN
     | 	GTAN
     |	GEQ
     |	LEQ
     |  NE
     | 	NEWLINE
     |  ERROR String
     deriving (Eq, Show)

mkIdentTok :: String -> Token
mkIdentTok lexeme = case lexeme of
			 "is" -> IS
                         "equals" -> EQUALS
                         "or" -> OR
                         "and" -> AND
                         "else" -> ELSE
                         "not" -> NOT
			 "for" -> FOR
			 "o" -> OF
			 "func" -> FUNC
			 lexeme -> IDENT lexeme

mkNewLineTok :: String -> Token
mkNewLineTok lexeme = NEWLINE

mkRealTok :: String -> Token
mkRealTok lexeme = REAL lexeme

mkIntTok :: String -> Token
mkIntTok lexeme = INTEGER lexeme

mkSpecialTok :: String -> Token
mkSpecialTok lexeme = case lexeme of
                           "," -> COMMA
			   "(" -> LPAR
			   ")" -> RPAR
			   "{" -> LCURL
			   "}" -> RCURL
			   "%" -> PERCENT
			   "$" -> DOLLAR
			   _ -> ERROR ("Special token not found " ++ lexeme)

mkOperatorTok :: String -> Token
mkOperatorTok lexeme = case lexeme of
	      	       	    "=" -> IS
			    "==" -> EQUALS
			    "!=" -> NE
			    "<" -> LTAN
			    ">" -> GTAN
			    ">=" -> GEQ
			    "<=" -> LEQ
			    "o" -> OF
			    "." -> DOT
			    "+" -> POSITIVE
			    "-" -> NEGATIVE
			    "*" -> ASTRIX
			    "/" -> SLASH
			    "^" -> CARROT
			    _ -> ERROR ("Operator token not found " ++ lexeme)

genTokens :: String -> [Token]
genTokens source = alexScanTokens source

}
