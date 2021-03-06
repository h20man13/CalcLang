{-# LANGUAGE MultiParamTypeClasses #-}
module Interpreter(interpret, Value(..), STable(..), FTable(..), VTable(..)) where

import Parser
import Numeric 

data Value
  = IntVal Integer
  | RealVal Double
  | TupleVal [Value]
  | SetVal [Value]
  | DollarVal Double
  | PercentVal Double
  | BoolVal Bool
  | ErrorVal [String]
  deriving Show

data STable a = SymbolTable [(String, a)]
type FTable = STable ([String], Expression)
type VTable = STable Value

toStr :: [Value] -> String
toStr list = case list of
            [] -> ""
            (val:[]) -> toString val
            (val:rest) -> (toStr rest) ++ ", " ++ (toString val)

toErrorLog :: [String] -> String
toErrorLog errors = case errors of
                      [] -> ""
                      (current:[]) -> current ++ "\n"
                      (current:rest) -> (toErrorLog rest) ++ current ++ "\n" 

toString :: Value -> String
toString val = case val of
                 IntVal val -> show val
                 RealVal val -> show val
                 TupleVal val -> "(" ++ (toStr val) ++ ")"
                 SetVal val -> "{" ++ (toStr val) ++ "}"
                 DollarVal val -> "$" ++ (showFFloat (Just 2) val "")
                 PercentVal val -> (showFFloat (Just 2) (val*100.0) "") ++ "%"
                 BoolVal val -> if val then "TRUE" else "FALSE"
                 ErrorVal val -> "<<<~~~ERROR~~~>>>\n\n" ++ (toErrorLog val) ++ "\n"

addEntry :: STable x -> (String, x) -> STable x
addEntry table entry = case table of
                         SymbolTable x -> SymbolTable (entry : x)

removeEntry :: (Eq x) => STable x -> String -> STable x
removeEntry table key = case table of
                          SymbolTable [] -> SymbolTable []
                          SymbolTable list -> SymbolTable (removeKey list key)

removeKey :: (Eq key) => [(key, a)] -> key -> [(key, a)]
removeKey list key = case list of
                       [] -> []
                       ((itemKey, _) : rest) -> case itemKey == key of
                                                  True -> rest
                                                  False -> removeKey rest key
                             
getEntry :: STable x -> String -> Maybe x
getEntry table key = case table of
                       SymbolTable [] -> Nothing
                       SymbolTable list -> getKey list key

getKey :: (Eq key) => [(key,a)] -> key -> Maybe a
getKey list key = case list of
                    [] -> Nothing
                    ((elemKey, elem) : rest) -> case elemKey == key of
                                                  True -> Just elem
                                                  False -> getKey rest key

interpret :: Line -> VTable -> FTable -> IO (VTable, FTable)
interpret line vT fT = interpretLine line vT fT

interpretLine :: Line -> VTable -> FTable -> IO (VTable, FTable)
interpretLine line vT fT = case line of
                     FunctionAssignment name param expr -> return (vT, addEntry fT (name,(param, expr)))
                     VariableAssignment name expr -> do
                                                     let val = (interpretExpression expr vT fT)
                                                     case val of
                                                       ErrorVal _ -> do
                                                                     (putStrLn (toString val))
                                                                     return (vT, fT)
                                                       val -> return (addEntry vT (name, val), fT)
                     PrintExpression expr -> do
                                             putStrLn (toString (interpretExpression expr vT fT))
                                             return (vT, fT)
                     
interpretExpression :: Expression -> VTable -> FTable -> Value
interpretExpression exp vT fT = case exp of
                            ForExpression ifTrue cond ifFalse -> forV ifTrue (interpretLogical cond vT fT) ifFalse vT fT
                            Logical expr -> interpretLogical expr vT fT

interpretLogical :: Logical -> VTable -> FTable -> Value
interpretLogical exp vT fT = case exp of
                               And exp1 exp2 -> andV (interpretLogical exp1 vT fT) (interpretRelational exp2 vT fT)
                               Or exp1 exp2 -> orV (interpretLogical exp1 vT fT) (interpretRelational exp2 vT fT)
                               Relational exp -> interpretRelational exp vT fT
                  
interpretRelational :: Relational -> VTable -> FTable -> Value
interpretRelational exp vT fT = case exp of
                                  Equal exp1 exp2 -> equalV (interpretExpr1 exp1 vT fT) (interpretExpr1 exp2 vT fT)
                                  NotEqual exp1 exp2 -> notEqualV (interpretExpr1 exp1 vT fT) (interpretExpr1 exp2 vT fT)
                                  Less exp1 exp2 -> lessV (interpretExpr1 exp1 vT fT) (interpretExpr1 exp2 vT fT)
                                  Greater exp1 exp2 -> greaterV (interpretExpr1 exp1 vT fT) (interpretExpr1 exp2 vT fT)
                                  LessOrEqual exp1 exp2 -> lessOrEqualV (interpretExpr1 exp1 vT fT) (interpretExpr1 exp2 vT fT)
                                  GreaterOrEqual exp1 exp2 -> greaterOrEqualV (interpretExpr1 exp1 vT fT) (interpretExpr1 exp2 vT fT)
                                  Expr1 exp -> interpretExpr1 exp vT fT
                    
interpretExpr1 :: Expr1 -> VTable -> FTable -> Value
interpretExpr1 exp vT fT = case exp of
                       Add exp1 exp2 -> addV (interpretExpr1 exp1 vT fT) (interpretTerm exp2 vT fT)
                       Sub exp1 exp2 -> subtractV (interpretExpr1 exp1 vT fT) (interpretTerm exp2 vT fT)
                       Term exp -> interpretTerm exp vT fT

interpretTerm :: Term -> VTable -> FTable -> Value
interpretTerm exp vT fT = case exp of
                            Mult exp1 exp2 -> multiplyV (interpretTerm exp1 vT fT) (interpretUnary exp2 vT fT)
                            Divide exp1 exp2 -> divideV (interpretTerm exp1 vT fT) (interpretUnary exp2 vT fT)
                            DotProduct exp1 exp2 -> dotProductV (interpretTerm exp1 vT fT) (interpretUnary exp2 vT fT)
                            Unary exp -> interpretUnary exp vT fT

interpretUnary :: Unary -> VTable -> FTable -> Value
interpretUnary exp vT fT = case exp of
                             Neg exp -> negV (interpretUnary exp vT fT)
                             Pos exp -> (interpretUnary exp vT fT)
                             Not exp -> notV (interpretUnary exp vT fT)
                             Power exp -> interpretPower exp vT fT

interpretPower :: Power -> VTable -> FTable -> Value
interpretPower exp vT fT = case exp of
                        Exponent exp1 exp2 -> exponentV (interpretPrimary exp1 vT fT)(interpretPower exp2 vT fT)
                        Primary exp -> interpretPrimary exp vT fT

interpretPrimary :: Primary -> VTable -> FTable -> Value
interpretPrimary exp vT fT = case exp of
                         Set expList -> SetVal (map (\x -> interpretExpression x vT fT) expList)
                         Tuple expList -> TupleVal (map (\x -> interpretExpression x vT fT) expList)
                         ParExpression expr -> interpretExpression expr vT fT
                         Dollar numValue -> DollarVal (asReal (interpretNumber numValue))
                         Percent numValue -> PercentVal ((asReal (interpretNumber numValue)) / 100.0)
                         Number num -> interpretNumber num
                         Identifier ident -> do
                                             let entry = getEntry vT ident
                                             case entry of
                                               Just val -> val
                                               Nothing -> ErrorVal [("Variable " ++ ident ++ " has not been declared yet")]
                         FCall name exprs -> do
                                             let entry = getEntry fT name
                                             case entry of
                                                      Just (params, retExpr) -> do
                                                                                let solvedExprs = (map (\x -> interpretExpression x vT fT) exprs)
                                                                                let zippedData = (zip params solvedExprs)
                                                                                let vTable = (foldl (\table tuple -> addEntry table tuple) vT zippedData)
                                                                                let retVal = (interpretExpression retExpr vTable fT)
                                                                                (retVal)
                                                      Nothing -> ErrorVal [("Function " ++ name ++ " not found")]

interpretNumber :: Number -> Value                                 
interpretNumber numType = case numType of
                            IntNode num -> IntVal (read num :: Integer)
                            RealNode num -> RealVal (read num :: Double)

exponentV :: Value -> Value -> Value
exponentV v1 v2 = case (v1,v2) of
                 (ErrorVal v1, ErrorVal v2) -> ErrorVal (v1 ++ v2)
                 (ErrorVal v1, _) -> ErrorVal v1
                 (_, ErrorVal v2) -> ErrorVal v2
                 (TupleVal v1, _) -> TupleVal (map (\x -> (exponentV x v2)) v1)
                 (SetVal v1, _) -> SetVal (map (\x -> (exponentV x v2)) v1)
                 (IntVal v1, IntVal v2) -> IntVal (v1^v2)
                 (IntVal v1, BoolVal v2) -> IntVal (v1^(if v2 then 1 else 0))
                 (IntVal v1, RealVal v2) -> RealVal ((fromInteger v1 :: Double)**v2)
                 (RealVal v1, IntVal v2) -> RealVal (v1**(fromInteger v2 :: Double))
                 (RealVal v1, BoolVal v2) -> RealVal (v1**(if v2 then 1.0 else 0.0))
                 (RealVal v1, RealVal v2) -> RealVal (v1**v2)
                 (RealVal v1, PercentVal v2) -> RealVal (v1**v2)
                 (BoolVal v1, IntVal v2) -> IntVal ((if v1 then 1 else 0)^v2)
                 (BoolVal v1, BoolVal v2) -> BoolVal (((if v1 then 1 else 0)^(if v2 then 1 else 0) /= 0))
                 (BoolVal v1, RealVal v2) -> RealVal ((if v1 then 1.0 else 0.0)**v2)
                 (PercentVal v1, RealVal v2) -> PercentVal (v1**v2)
                 (PercentVal v1, IntVal v2) -> PercentVal (v1**(fromInteger v2 :: Double))
                 (x,y) -> ErrorVal [("Unable to multiply " ++ show x ++ " by " ++ show y)]


divideV :: Value -> Value -> Value
divideV v1 v2 = case (v1,v2) of
                 (ErrorVal v1, ErrorVal v2) -> ErrorVal (v1 ++ v2)
                 (ErrorVal v1, _) -> ErrorVal v1
                 (_, ErrorVal v2) -> ErrorVal v2
                 (TupleVal v1, SetVal v2) -> TupleVal (map (\(x,y) ->divideV x y) (zip v1 v2))
                 (TupleVal v1, TupleVal v2) -> TupleVal (map (\(x,y) -> divideV x y) (zip v1 v2))
                 (SetVal v1, TupleVal v2) -> SetVal (map (\(x,y) -> divideV x y) (zip v1 v2))
                 (SetVal v1, SetVal v2) -> SetVal (map (\(x,y) -> divideV x y) (zip v1 v2))
                 (_, TupleVal v2) -> TupleVal (map (\x -> (divideV v1 x)) v2)
                 (_, SetVal v2) -> SetVal (map (\x -> (divideV v1 x)) v2)
                 (TupleVal v1, _) -> TupleVal (map (\x -> (divideV x v2)) v1)
                 (SetVal v1, _) -> SetVal (map (\x -> (divideV x v2)) v1)
                 (IntVal v1, IntVal v2) -> RealVal ((fromInteger v1 :: Double) / (fromInteger v2 :: Double))
                 (IntVal v1, BoolVal v2) -> RealVal ((fromInteger v1 :: Double) / (if v2 then 1.0 else 0.0))
                 (IntVal v1, RealVal v2) -> RealVal ((fromInteger v1 :: Double) / v2)
                 (IntVal v1, PercentVal v2) -> RealVal ((fromInteger v1 :: Double) / v2)
                 (RealVal v1, IntVal v2) -> RealVal (v1 / (fromInteger v2 :: Double))
                 (RealVal v1, BoolVal v2) -> RealVal (v1 / (if v2 then 1.0 else 0.0))
                 (RealVal v1, RealVal v2) -> RealVal (v1 / v2)
                 (RealVal v1, PercentVal v2) -> RealVal (v1 / v2)
                 (BoolVal v1, IntVal v2) -> RealVal ((if v1 then 1.0 else 0.0)/(fromInteger v2 :: Double))
                 (BoolVal v1, BoolVal v2) -> RealVal ((if v1 then 1 else 0)/(if v2 then 1 else 0))
                 (BoolVal v1, RealVal v2) -> RealVal ((if v1 then 1.0 else 0.0)/v2)
                 (BoolVal v1, PercentVal v2) -> RealVal ((if v1 then 1.0 else 0.0)/v2)
                 (DollarVal v1, DollarVal v2) -> RealVal (v1 / v2)
                 (DollarVal v1, PercentVal v2) -> DollarVal (v1 / v2)
                 (DollarVal v1, IntVal v2) -> DollarVal (v1 / (fromInteger v2 :: Double))
                 (DollarVal v1, RealVal v2) -> DollarVal (v1 / v2)
                 (PercentVal v1, PercentVal v2) -> RealVal (v1 / v2)
                 (PercentVal v1, RealVal v2) -> PercentVal (v1 / v2)
                 (PercentVal v1, IntVal v2) -> PercentVal (v1 / (fromInteger v2 :: Double))
                 (x,y) -> ErrorVal [("Unable to divide " ++ show x ++ " by " ++ show y)]

multiplyV :: Value -> Value -> Value
multiplyV v1 v2 = case (v1,v2) of
                 (ErrorVal v1, ErrorVal v2) -> ErrorVal (v1 ++ v2)
                 (ErrorVal v1, _) -> ErrorVal v1
                 (_, ErrorVal v2) -> ErrorVal v2
                 (TupleVal v1, SetVal v2) -> TupleVal (map (\(x,y) -> multiplyV x y) (zip v1 v2))
                 (TupleVal v1, TupleVal v2) -> TupleVal (map (\(x,y) -> multiplyV x y) (zip v1 v2))
                 (SetVal v1, TupleVal v2) -> SetVal (map (\(x,y) -> multiplyV x y) (zip v1 v2))
                 (SetVal v1, SetVal v2) -> SetVal (map (\(x,y) -> multiplyV x y) (zip v1 v2))
                 (_, TupleVal v2) -> TupleVal (map (\x -> (multiplyV v1 x)) v2)
                 (_, SetVal v2) -> SetVal (map (\x -> (multiplyV v1 x)) v2)
                 (TupleVal v1, _) -> TupleVal (map (\x -> (multiplyV x v2)) v1)
                 (SetVal v1, _) -> SetVal (map (\x -> (multiplyV x v2)) v1)
                 (IntVal v1, IntVal v2) -> IntVal (v1 * v2)
                 (IntVal v1, BoolVal v2) -> IntVal (v1 * (if v2 then 1 else 0))
                 (IntVal v1, RealVal v2) -> RealVal ((fromInteger v1 :: Double) * v2)
                 (IntVal v1, PercentVal v2) -> RealVal ((fromInteger v1 :: Double) * v2)
                 (IntVal v1, DollarVal v2) -> DollarVal ((fromInteger v1 :: Double) * v2)
                 (RealVal v1, IntVal v2) -> RealVal (v1 * (fromInteger v2 :: Double))
                 (RealVal v1, BoolVal v2) -> RealVal (v1 * (if v2 then 1.0 else 0.0))
                 (RealVal v1, RealVal v2) -> RealVal (v1 * v2)
                 (RealVal v1, PercentVal v2) -> RealVal (v1 * v2)
                 (RealVal v1, DollarVal v2) -> DollarVal (v1 * v2)
                 (BoolVal v1, IntVal v2) -> IntVal ((if v1 then 1 else 0) * v2)
                 (BoolVal v1, BoolVal v2) -> BoolVal (((if v1 then 1 else 0)*(if v2 then 1 else 0)) /= 0)
                 (BoolVal v1, RealVal v2) -> RealVal ((if v1 then 1.0 else 0.0) * v2)
                 (BoolVal v1, PercentVal v2) -> RealVal ((if v1 then 1.0 else 0.0) * v2)
                 (BoolVal v1, DollarVal v2) -> DollarVal ((if v1 then 1.0 else 0.0) * v2)
                 (DollarVal v1, PercentVal v2) -> DollarVal (v1 * v2)
                 (DollarVal v1, IntVal v2) -> DollarVal (v1 * (fromInteger v2 :: Double))
                 (DollarVal v1, RealVal v2) -> DollarVal (v1 * v2)
                 (DollarVal v1, BoolVal v2) -> DollarVal (v1 * (if v2 then 1.0 else 0.0))
                 (PercentVal v1, PercentVal v2) -> PercentVal (v1*v2)
                 (PercentVal v1, RealVal v2) -> PercentVal (v1*v2)
                 (PercentVal v1, IntVal v2) -> PercentVal (v1 * (fromInteger v2 :: Double))
                 (PercentVal v1, BoolVal v2) -> PercentVal (v1 * (if v2 then 1.0 else 0.0))
                 (x,y) -> ErrorVal [("Unable to multiply " ++ show x ++ " by " ++ show y)]

dotProductV :: Value -> Value -> Value
dotProductV v1 v2 = case (v1,v2) of
                 (ErrorVal v1, ErrorVal v2) -> ErrorVal (v1 ++ v2)
                 (ErrorVal v1, _) -> ErrorVal v1
                 (_, ErrorVal v2) -> ErrorVal v2
                 (TupleVal v1, SetVal v2) -> (foldl (\x y -> addV x y) (IntVal 0) (map (\(x,y) -> multiplyV x y) (zip v1 v2))) 
                 (TupleVal v1, TupleVal v2) -> (foldl (\x y -> addV x y) (IntVal 0) (map (\(x,y) -> multiplyV x y) (zip v1 v2))) 
                 (SetVal v1, TupleVal v2) -> (foldl (\x y -> addV x y) (IntVal 0) (map (\(x,y) -> multiplyV x y) (zip v1 v2))) 
                 (SetVal v1, SetVal v2) -> (foldl (\x y -> addV x y) (IntVal 0) (map (\(x,y) -> multiplyV x y) (zip v1 v2))) 
                 (x,y) -> ErrorVal [("Unable to perform dot product on  " ++ show x ++ " and " ++ show y)]

addV :: Value -> Value -> Value
addV v1 v2 = case (v1,v2) of
                 (ErrorVal v1, ErrorVal v2) -> ErrorVal (v1 ++ v2)
                 (ErrorVal v1, _) -> ErrorVal v1
                 (_, ErrorVal v2) -> ErrorVal v2
                 (TupleVal v1, SetVal v2) -> TupleVal (map (\(x, y) -> addV x y) (zip v1 v2))
                 (TupleVal v1, TupleVal v2) -> TupleVal (map (\(x, y) -> addV x y) (zip v1 v2))
                 (SetVal v1, TupleVal v2) -> SetVal (map (\(x, y) -> addV x y) (zip v1 v2))
                 (SetVal v1, SetVal v2) -> SetVal (map (\(x, y) -> addV x y) (zip v1 v2))
                 (_, TupleVal v2) -> TupleVal (map (\x -> (addV v1 x)) v2)
                 (_, SetVal v2) -> SetVal (map (\x -> (addV v1 x)) v2)
                 (TupleVal v1, _) -> TupleVal (map (\x -> (addV x v2)) v1)
                 (SetVal v1, _) -> SetVal (map (\x -> (addV x v2)) v1)
                 (IntVal v1, IntVal v2) -> IntVal (v1 + v2)
                 (IntVal v1, BoolVal v2) -> IntVal (v1 + (if v2 then 1 else 0))
                 (IntVal v1, RealVal v2) -> RealVal ((fromInteger v1 :: Double) + v2)
                 (RealVal v1, IntVal v2) -> RealVal (v1 + (fromInteger v2 :: Double))
                 (RealVal v1, BoolVal v2) -> RealVal (v1 + (if v2 then 1.0 else 0.0))
                 (RealVal v1, RealVal v2) -> RealVal (v1 + v2)
                 (BoolVal v1, IntVal v2) -> IntVal ((if v1 then 1 else 0)+v2)
                 (BoolVal v1, BoolVal v2) -> IntVal ((if v1 then 1 else 0)+(if v2 then 1 else 0))
                 (BoolVal v1, RealVal v2) -> RealVal ((if v1 then 1.0 else 0.0) + v2)
                 (DollarVal v1, DollarVal v2) -> DollarVal(v1+v2)
                 (PercentVal v1, PercentVal v2) -> PercentVal(v1+v2)
                 (x,y) -> ErrorVal [("Unable to add " ++ show x ++ " and " ++ show y)]

subtractV :: Value -> Value -> Value
subtractV v1 v2 = addV v1 (negV v2)

negV :: Value -> Value
negV v1 = case v1 of
                 ErrorVal v1 -> ErrorVal v1
                 TupleVal v1 -> TupleVal (map (\x -> negV x) v1)
                 SetVal v1 -> SetVal (map (\x -> negV x) v1)
                 IntVal v1 -> IntVal (-v1)
                 RealVal v1 -> RealVal (-v1)
                 BoolVal v1 -> IntVal (-(if v1 then 1 else 0))
                 DollarVal v1 -> DollarVal (-v1)
                 PercentVal v1 -> PercentVal (-v1)
                 x -> ErrorVal [("Unable to negate " ++ show x)]

notV :: Value -> Value
notV v1 = case v1 of
                 ErrorVal v1 -> ErrorVal v1
                 TupleVal v1 -> TupleVal (map (\x -> notV x) v1)
                 SetVal v1 -> SetVal (map (\x -> notV x) v1)
                 IntVal v1 -> BoolVal (v1 /= 0)
                 RealVal v1 -> BoolVal (v1 /= 0.0)
                 BoolVal v1 -> BoolVal (not v1)
                 x -> ErrorVal [("Unable to perform logical not on " ++ show x)]

andV :: Value -> Value -> Value
andV v1 v2 = case (v1, v2) of
              (ErrorVal v1, ErrorVal v2) -> ErrorVal (v1 ++ v2)
              (ErrorVal v1, _) -> ErrorVal v1
              (_, ErrorVal v2) -> ErrorVal v2
              (_, TupleVal v2) -> ErrorVal [("Error: Tuple value found in boolean expression")]
              (_, SetVal v2) -> ErrorVal [("Error: Set value found in boolean expression")]
              (TupleVal v1, _) -> ErrorVal [("Error: Tuple value found in boolean expression")]
              (SetVal v1, _) -> ErrorVal [("Error: Set value found in boolean expression")]
              (DollarVal v1, _) -> ErrorVal [("Error: Dollar value found in boolean expression")]
              (_,DollarVal v2) -> ErrorVal [("Error: Dollar value found in boolean expression")]
              (PercentVal v1, _) -> ErrorVal [("Error: Dollar value found in boolean expression")]
              (_,PercentVal v2) -> ErrorVal [("Error: Dollar value found in boolean expression")]
              (v1,v2) -> BoolVal((asBool v1) && (asBool v2))

orV :: Value -> Value -> Value
orV v1 v2 = case (v1, v2) of
              (ErrorVal v1, ErrorVal v2) -> ErrorVal (v1 ++ v2)
              (ErrorVal v1, _) -> ErrorVal v1
              (_, ErrorVal v2) -> ErrorVal v2
              (_, TupleVal v2) -> ErrorVal [("Error: Tuple value found in boolean expression")]
              (_, SetVal v2) -> ErrorVal [("Error: Set value found in boolean expression")]
              (TupleVal v1, _) -> ErrorVal [("Error: Tuple value found in boolean expression")]
              (SetVal v1, _) -> ErrorVal [("Error: Set value found in boolean expression")]
              (DollarVal v1, _) -> ErrorVal [("Error: Dollar value found in boolean expression")]
              (_,DollarVal v2) -> ErrorVal [("Error: Dollar value found in boolean expression")]
              (PercentVal v1, _) -> ErrorVal [("Error: Dollar value found in boolean expression")]
              (_,PercentVal v2) -> ErrorVal [("Error: Dollar value found in boolean expression")]
              (v1,v2) -> BoolVal((asBool v1) || (asBool v2))

equalV :: Value -> Value -> Value
equalV v1 v2 = case (v1,v2) of
                 (ErrorVal v1, ErrorVal v2) -> ErrorVal (v1 ++ v2)
                 (ErrorVal v1, _) -> ErrorVal v1
                 (_, ErrorVal v2) -> ErrorVal v2
                 (TupleVal v1, SetVal v2) -> foldl (\x y -> andV x y) (BoolVal True) (map (\(x,y) -> equalV x y) (zip v1 v2))
                 (TupleVal v1, TupleVal v2) -> foldl (\x y -> andV x y) (BoolVal True) (map (\(x,y) -> equalV x y) (zip v1 v2))
                 (SetVal v1, TupleVal v2) -> foldl (\x y -> andV x y) (BoolVal True) (map (\(x,y) -> equalV x y) (zip v1 v2))
                 (SetVal v1, SetVal v2) -> foldl (\x y -> andV x y) (BoolVal True) (map (\(x,y) -> equalV x y) (zip v1 v2))
                 (IntVal v1, IntVal v2) -> BoolVal (v1 == v2)
                 (IntVal v1, BoolVal v2) -> BoolVal (v1 == (if v2 then 1 else 0))
                 (IntVal v1, RealVal v2) -> BoolVal ((fromInteger v1 :: Double) == v2)
                 (RealVal v1, IntVal v2) -> BoolVal (v1 == (fromInteger v2 :: Double))
                 (RealVal v1, BoolVal v2) -> BoolVal (v1 == if v2 then 1.0 else 0.0)
                 (RealVal v1, RealVal v2) -> BoolVal (v1 == v2)
                 (BoolVal v1, IntVal v2) -> BoolVal ((if v1 then 1 else 0) == v2)
                 (BoolVal v1, BoolVal v2) -> BoolVal (v1 == v2)
                 (BoolVal v1, RealVal v2) -> BoolVal ((if v1 then 1.0 else 2.0) == v2)
                 (DollarVal v1, DollarVal v2) -> BoolVal(v1 == v2)
                 (PercentVal v1, PercentVal v2) -> BoolVal(v1 == v2)
                 (x,y) -> ErrorVal [("Unable to check for equality on types " ++ show x ++ " and " ++ show y)]

notEqualV :: Value -> Value -> Value
notEqualV v1 v2 = notV (equalV v1 v2)

lessV :: Value -> Value -> Value
lessV v1 v2 = case (v1,v2) of
                 (ErrorVal v1, ErrorVal v2) -> ErrorVal (v1 ++ v2)
                 (ErrorVal v1, _) -> ErrorVal v1
                 (_, ErrorVal v2) -> ErrorVal v2
                 (IntVal v1, IntVal v2) -> BoolVal (v1 < v2)
                 (IntVal v1, BoolVal v2) -> BoolVal (v1 < (if v2 then 1 else 0))
                 (IntVal v1, RealVal v2) -> BoolVal ((fromInteger v1 :: Double) < v2)
                 (RealVal v1, IntVal v2) -> BoolVal (v1 < (fromInteger v2 :: Double))
                 (RealVal v1, BoolVal v2) -> BoolVal (v1 < (if v2 then 1.0 else 0.0))
                 (RealVal v1, RealVal v2) -> BoolVal (v1 < v2)
                 (BoolVal v1, IntVal v2) -> BoolVal ((if v1 then 1 else 0) < v2)
                 (BoolVal v1, BoolVal v2) -> BoolVal ((if v1 then 1 else 0) < (if v2 then 1 else 0))
                 (BoolVal v1, RealVal v2) -> BoolVal ((if v1 then 1.0 else 0.0) < v2)
                 (DollarVal v1, DollarVal v2) -> BoolVal(v1<v2)
                 (PercentVal v1, PercentVal v2) -> BoolVal(v1<v2)
                 (x,y) -> ErrorVal [("Unable to check for equality on types " ++ show x ++ " and " ++ show y)]

greaterV :: Value -> Value -> Value
greaterV v1 v2 = case (v1,v2) of
                   (ErrorVal v1, ErrorVal v2) -> ErrorVal (v1 ++ v2)
                   (ErrorVal v1, _) -> ErrorVal v1
                   (_, ErrorVal v2) -> ErrorVal v2
                   (IntVal v1, IntVal v2) -> BoolVal (v1 > v2)
                   (IntVal v1, BoolVal v2) -> BoolVal (v1 > (if v2 then 1 else 0))
                   (IntVal v1, RealVal v2) -> BoolVal ((fromInteger v1 :: Double) > v2)
                   (RealVal v1, IntVal v2) -> BoolVal (v1 > (fromInteger v2 :: Double))
                   (RealVal v1, BoolVal v2) -> BoolVal (v1 > (if v2 then 1.0 else 0.0))
                   (RealVal v1, RealVal v2) -> BoolVal (v1 > v2)
                   (BoolVal v1, IntVal v2) -> BoolVal ((if v1 then 1 else 0) > v2)
                   (BoolVal v1, BoolVal v2) -> BoolVal ((if v1 then 1 else 0) > (if v2 then 1 else 0))
                   (BoolVal v1, RealVal v2) -> BoolVal ((if v1 then 1.0 else 0.0) > v2)
                   (DollarVal v1, DollarVal v2) -> BoolVal(v1 > v2)
                   (PercentVal v1, PercentVal v2) -> BoolVal(v1 > v2)
                   (x,y) -> ErrorVal [("Unable to check for equality on types " ++ show x ++ " and " ++ show y)]

lessOrEqualV :: Value -> Value -> Value
lessOrEqualV v1 v2 = notV (greaterV v1 v2)

greaterOrEqualV :: Value -> Value -> Value
greaterOrEqualV v1 v2 = notV (lessV v1 v2)

forV :: Logical -> Value -> Expression -> VTable -> FTable -> Value
forV ifTrue cond ifFalse vT fT = case cond of
                             ErrorVal error -> ErrorVal error
                             TupleVal val -> ErrorVal ["In for expression conditional resulted in a tuple"]
                             SetVal val -> ErrorVal ["In for expression conditional resulted in a set"]
                             DollarVal val -> ErrorVal ["In for expression conditional resulted in a dollar amount"]
                             PercentVal val -> ErrorVal ["In for expression conditional resulted in a percent amount"]
                             cond -> if asBool cond then interpretLogical ifTrue vT fT else interpretExpression ifFalse vT fT

asBool :: Value -> Bool
asBool val = case val of
               BoolVal val -> val
               IntVal val -> val /= 0
               RealVal val -> val /= 0
               PercentVal val -> val /= 0

asReal :: Value -> Double
asReal val = case val of
               IntVal val -> (fromInteger val :: Double)
               DollarVal val -> val
               RealVal val -> val
               PercentVal val -> val
               BoolVal val -> if val then 1.0 else 0.0
               _ -> -1.0
