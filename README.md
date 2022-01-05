# CalcLang
CalcLang is an interpreted language designed to be used in a Math class. 
Oroginally it was created as a reply with scala however i switched it over to haskell for performance reasons.

# Scala
-- The parser and lexer is hand generated it comes with maven for the build and distribution. To get started just run maven and execute the jar file.

#Haskell
-- The lexer was generated with alex and the parser was generated with alex. The Haskell design also provides better error detection and runs much quicker.

--The main difference with this version is that defining function syntax is slightly different.
--Scala -> it is f(x) = expr
--Haskell -> it is func f(x) = expr

The reason I did this was because the parser generator said their was an imbiguity which was something I was able to get out when I wrote my own grammer.

Speaking of the grammar the grammar of CalcLang is below

Taken from haskell parser generator

  Line -> Ident '=' Expression 'end'                      (1)
	Line -> Ident '(' Paramaters ')' '=' Expression 'end'   (2)
	Line -> Expression 'end'                                (3)
	Paramaters -> Ident                                     (4)
	Paramaters -> Paramaters ',' Ident                      (5)
	Expression -> Logical 'for' Logical 'else' Expression   (6)
	Expression -> Logical                              (7)
	Logical -> Logical 'and' Relational                (8)
	Logical -> Logical 'or' Relational                 (9)
	Logical -> Relational                              (10)
	Relational -> Expr1 '<' Expr1                      (11)
	Relational -> Expr1 '>' Expr1                      (12)
	Relational -> Expr1 '<=' Expr1                     (13)
	Relational -> Expr1 '>=' Expr1                     (14)
	Relational -> Expr1 '!=' Expr1                     (15)
	Relational -> Expr1 '==' Expr1                     (16)
	Relational -> Expr1                                (17)
	Expr1 -> Expr1 '+' Term                            (18)
	Expr1 -> Expr1 '-' Term                            (19)
	Expr1 -> Term                                      (20)
	Term -> Term '*' Unary                             (21)
	Term -> Term '/' Unary                             (22)
	Term -> Term '.' Unary                             (23)
	Term -> Unary                                      (24)
	Unary -> '-' Unary                                 (25)
	Unary -> 'not' Unary                               (26)
	Unary -> '+' Unary                                 (27)
	Unary -> Power                                     (28)
	Power -> Primary '^' Power                         (29)
	Power -> Primary                                   (30)
	Primary -> '(' Expression ')'                      (31)
	Primary -> '(' Expressions ')'                     (32)
	Primary -> '(' Applications ')' '(' Expressions ')'   (33)
	Primary -> '{' Expressions '}'                     (34)
	Primary -> Ident '(' Expressions ')'               (35)
	Primary -> Ident                                   (36)
	Primary -> '$' Number                              (37)
	Primary -> Number '%'                              (38)
	Primary -> Number                                  (39)
	Number -> IntT                                     (40)
	Number -> RealT                                    (41)
	Expressions -> Expression                          (42)
	Expressions -> Expressions ',' Expression          (43)
	Applications -> Ident                              (44)
	Applications -> Applications 'o' Ident             (45)
