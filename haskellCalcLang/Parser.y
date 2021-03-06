{
  module Parser(parseAst,Line(..), Line(..),Expression(..),Relational(..),Logical(..),Expr1(..),Term(..),Unary(..),Power(..),Primary(..),Number(..)) where
import Lexer
}

%name parseAst
%tokentype { Token }
%error { parseError }

%token
'for' { FOR }
'func' { FUNC }
'=' { IS }
'else' { ELSE }
'not' { NOT }
'and' { AND }
'or' { OR }
'==' { EQUALS }
')' { RPAR }
'(' { LPAR }
'{' { LCURL }
'}' { RCURL }
',' { COMMA }
'+' { POSITIVE }
'-' { NEGATIVE }
'^' { CARROT }
'*' { ASTRIX }
'/' { SLASH }
'.' { DOT }
'>=' { GEQ }
'<=' { LEQ }
'<' { LTAN }
'>' { GTAN }
'!=' { NE }
'o' { OF }
'$' { DOLLAR }
'%' { PERCENT }
IntT { INTEGER $$ }
Ident { IDENT $$ }
RealT { REAL $$ }
'end' { NEWLINE }

%%

Line :: { Line }
Line : Ident '=' Expression 'end' { VariableAssignment $1 $3 }
     | 'func' Ident '(' Paramaters ')' '=' Expression 'end' { FunctionAssignment $2 $4 $7 }
     | Expression 'end' { PrintExpression $1 }

Paramaters :: { [String] }
Paramaters : Ident { [$1] }
           | Paramaters ',' Ident { $3 : $1 }

Expression :: { Expression }
Expression : Logical 'for' Logical 'else' Expression { ForExpression $1 $3 $5 }
           | Logical { Logical $1 }

Logical :: { Logical }	   
Logical : Logical 'and' Relational { And $1 $3 }
        | Logical 'or' Relational { Or $1 $3 }
        | Relational { Relational $1 }

Relational :: { Relational }
Relational : Expr1 '<' Expr1 { Less $1 $3 }
           | Expr1 '>' Expr1 { Greater $1 $3 }
           | Expr1 '<=' Expr1 { LessOrEqual $1 $3 }
           | Expr1 '>=' Expr1 { GreaterOrEqual $1 $3 }
           | Expr1 '!=' Expr1 { NotEqual $1 $3 }
           | Expr1 '==' Expr1 { Equal $1 $3 }
           | Expr1 { Expr1 $1 }

Expr1 :: { Expr1 }
Expr1 : Expr1 '+' Term { Add $1 $3 }
      | Expr1 '-' Term { Sub $1 $3 }
      | Term { Term $1 }

Term :: { Term }
Term : Term '*' Unary { Mult $1 $3 }
     | Term '/' Unary { Divide $1 $3 }
     | Term '.' Unary { DotProduct $1 $3 }
     | Unary { Unary $1 }

Unary :: { Unary }
Unary : '-' Unary { Neg $2 }
      | 'not' Unary { Not $2 }
      | '+' Unary { Pos $2 }
      | Power { Power $1 }

Power :: { Power }
Power : Primary '^' Power  { Exponent $1 $3 }
      | Primary { Primary $1 }

Primary :: { Primary }
Primary : '(' Expression ')' { ParExpression $2 }
        | '(' Expressions ')' { Tuple $2 }
        | '(' Applications ')' '(' Expressions ')' { FApp $2 $5 }
        | '{' Expressions '}' { Set $2 }
        | Ident '(' Expressions ')' { FCall $1 $3 }
        | Ident { Identifier $1 }
        | '$' Number { Dollar $2 }
        | Number '%' { Percent $1 }
        | Number { Number $1 }

Number :: { Number }
Number : IntT { IntNode $1 }
       | RealT { RealNode $1 }

Expressions :: { [Expression] }
Expressions : Expression { [$1] }
| Expressions ',' Expression { $3 : $1 }

Applications :: { [String] }
Applications : Ident { [$1] }
             | Applications 'o' Ident { $3 : $1 }
      
{

data Line = VariableAssignment String Expression
          | FunctionAssignment String [String] Expression
          | PrintExpression Expression
          deriving(Show, Eq) 
		
data Expression
  = ForExpression Logical Logical Expression
  | Logical Logical
  deriving(Show, Eq) 

data Logical
  = And Logical Relational
  | Or Logical Relational
  | Relational Relational
  deriving(Show, Eq) 

data Relational
  = Less Expr1 Expr1
  | Greater Expr1 Expr1
  | LessOrEqual Expr1 Expr1
  | GreaterOrEqual Expr1 Expr1
  | NotEqual Expr1 Expr1
  | Equal Expr1 Expr1
  | Expr1 Expr1
  deriving(Show, Eq) 
  
data Expr1
  = Add Expr1 Term
  | Sub Expr1 Term
  | Term Term
  deriving(Show, Eq) 
  
data Term
  = Mult Term Unary
  | Divide Term Unary
  | DotProduct Term Unary
  | Unary Unary
  deriving(Show, Eq) 

data Unary
  = Neg Unary
  | Not Unary
  | Pos Unary
  | Power Power
  deriving(Show, Eq) 

data Power
  = Exponent Primary Power
  | Primary Primary
  deriving(Show, Eq)
  
data Primary
  = ParExpression Expression
  | Identifier String
  | Set [Expression]
  | Tuple [Expression]
  | FApp [String] [Expression]
  | FCall String [Expression]
  | Percent Number
  | Dollar Number
  | Number Number
  deriving(Show, Eq) 

data Number
  = IntNode String
  | RealNode String
  deriving(Show, Eq)

parseError :: [Token] -> a
parseError list = case list of
                    [] -> error "Unexpected EOF when matching"
                    list -> error ("Unexpected token " ++ (show (list !! 0)) ++ " found") 
  
}






