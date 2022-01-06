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

  <p>Line -> Ident '=' Expression 'end'                      (1)<br>
	Line -> Ident '(' Paramaters ')' '=' Expression 'end'   (2)<br>
	Line -> Expression 'end'                                (3)<br>
	Paramaters -> Ident                                     (4)<br>
	Paramaters -> Paramaters ',' Ident                      (5)<br>
	Expression -> Logical 'for' Logical 'else' Expression   (6)<br>
	Expression -> Logical                              (7)<br>
	Logical -> Logical 'and' Relational                (8)<br>
	Logical -> Logical 'or' Relational                 (9)<br>
	Logical -> Relational                              (10)<br>
	Relational -> Expr1 '<' Expr1                      (11)<br>
	Relational -> Expr1 '>' Expr1                      (12)<br>
	Relational -> Expr1 '<=' Expr1                     (13)<br>
	Relational -> Expr1 '>=' Expr1                     (14)<br>
	Relational -> Expr1 '!=' Expr1                     (15)<br>
	Relational -> Expr1 '==' Expr1                     (16)<br>
	Relational -> Expr1                                (17)<br>
	Expr1 -> Expr1 '+' Term                            (18)<br>
	Expr1 -> Expr1 '-' Term                            (19)<br>
	Expr1 -> Term                                      (20)<br>
	Term -> Term '*' Unary                             (21)<br>
	Term -> Term '/' Unary                             (22)<br>
	Term -> Term '.' Unary                             (23)<br>
	Term -> Unary                                      (24)<br>
	Unary -> '-' Unary                                 (25)<br>
	Unary -> 'not' Unary                               (26)<br>
	Unary -> '+' Unary                                 (27)<br>
	Unary -> Power                                     (28)<br>
	Power -> Primary '^' Power                         (29)<br>
	Power -> Primary                                   (30)<br>
	Primary -> '(' Expression ')'                      (31)<br>
	Primary -> '(' Expressions ')'                     (32)<br>
	Primary -> '(' Applications ')' '(' Expressions ')'   (33)<br>
	Primary -> '{' Expressions '}'                     (34)<br>
	Primary -> Ident '(' Expressions ')'               (35)<br>
	Primary -> Ident                                   (36)<br>
	Primary -> '$' Number                              (37)<br>
	Primary -> Number '%'                              (38)<br>
	Primary -> Number                                  (39)<br>
	Number -> IntT                                     (40)<br>
	Number -> RealT                                    (41)<br>
	Expressions -> Expression                          (42)<br>
	Expressions -> Expressions ',' Expression          (43)<br>
	Applications -> Ident                              (44)<br>
	Applications -> Applications 'o' Ident             (45)</p>
