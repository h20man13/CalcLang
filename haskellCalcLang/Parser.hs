{-# OPTIONS_GHC -w #-}
module Parser(parseAst,Line(..), Line(..),Expression(..),Relational(..),Logical(..),Expr1(..),Term(..),Unary(..),Power(..),Primary(..),Number(..)) where
import Lexer
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.8

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 (Line)
	| HappyAbsSyn5 ([String])
	| HappyAbsSyn6 (Expression)
	| HappyAbsSyn7 (Logical)
	| HappyAbsSyn8 (Relational)
	| HappyAbsSyn9 (Expr1)
	| HappyAbsSyn10 (Term)
	| HappyAbsSyn11 (Unary)
	| HappyAbsSyn12 (Power)
	| HappyAbsSyn13 (Primary)
	| HappyAbsSyn14 (Number)
	| HappyAbsSyn15 ([Expression])

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94 :: () => Int -> ({-HappyReduction (HappyIdentity) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (HappyIdentity) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45 :: () => ({-HappyReduction (HappyIdentity) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (HappyIdentity) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,313) ([0,26130,14848,0,0,4096,0,4,0,0,0,0,0,0,16384,0,97,0,0,0,0,0,24704,248,0,0,7,0,0,0,0,0,0,0,32768,0,0,0,1024,0,0,4096,0,26128,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,0,10240,0,0,0,0,516,0,0,0,0,0,26128,14848,0,26128,14848,0,0,0,0,0,0,0,512,0,0,0,0,0,0,0,0,6144,0,0,0,0,0,4352,0,0,256,256,0,512,0,0,0,0,0,512,0,0,0,0,0,1536,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,26128,14848,0,0,0,0,0,0,0,0,0,0,104,0,0,24576,0,0,24576,0,0,24576,0,0,24576,0,0,24576,0,0,0,7,0,0,7,0,24576,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4096,0,512,0,0,0,4096,0,0,0,0,26128,14848,0,0,0,0,0,0,0,4352,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,0,0,26128,14848,0,4352,0,0,0,0,0,26128,14848,0,0,0,0,4,0,0,0,4096,0,4352,0,0,0,0,0,0,0,0,26128,14848,0,0,16384,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseAst","Line","Paramaters","Expression","Logical","Relational","Expr1","Term","Unary","Power","Primary","Number","Expressions","Applications","'for'","'func'","'='","'else'","'not'","'and'","'or'","'=='","')'","'('","'{'","'}'","','","'+'","'-'","'^'","'*'","'/'","'.'","'>='","'<='","'<'","'>'","'!='","'o'","'$'","'%'","IntT","Ident","RealT","'end'","%eof"]
        bit_start = st * 48
        bit_end = (st + 1) * 48
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..47]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (18) = happyShift action_13
action_0 (21) = happyShift action_14
action_0 (26) = happyShift action_15
action_0 (27) = happyShift action_16
action_0 (30) = happyShift action_17
action_0 (31) = happyShift action_18
action_0 (42) = happyShift action_19
action_0 (44) = happyShift action_20
action_0 (45) = happyShift action_21
action_0 (46) = happyShift action_22
action_0 (4) = happyGoto action_3
action_0 (6) = happyGoto action_4
action_0 (7) = happyGoto action_5
action_0 (8) = happyGoto action_6
action_0 (9) = happyGoto action_7
action_0 (10) = happyGoto action_8
action_0 (11) = happyGoto action_9
action_0 (12) = happyGoto action_10
action_0 (13) = happyGoto action_11
action_0 (14) = happyGoto action_12
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (45) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 (19) = happyShift action_23
action_2 _ = happyFail (happyExpListPerState 2)

action_3 (48) = happyAccept
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (47) = happyShift action_53
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (17) = happyShift action_50
action_5 (22) = happyShift action_51
action_5 (23) = happyShift action_52
action_5 _ = happyReduce_7

action_6 _ = happyReduce_10

action_7 (24) = happyShift action_42
action_7 (30) = happyShift action_43
action_7 (31) = happyShift action_44
action_7 (36) = happyShift action_45
action_7 (37) = happyShift action_46
action_7 (38) = happyShift action_47
action_7 (39) = happyShift action_48
action_7 (40) = happyShift action_49
action_7 _ = happyReduce_17

action_8 (33) = happyShift action_39
action_8 (34) = happyShift action_40
action_8 (35) = happyShift action_41
action_8 _ = happyReduce_20

action_9 _ = happyReduce_24

action_10 _ = happyReduce_28

action_11 (32) = happyShift action_38
action_11 _ = happyReduce_30

action_12 (43) = happyShift action_37
action_12 _ = happyReduce_39

action_13 (45) = happyShift action_36
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (21) = happyShift action_14
action_14 (26) = happyShift action_15
action_14 (27) = happyShift action_16
action_14 (30) = happyShift action_17
action_14 (31) = happyShift action_18
action_14 (42) = happyShift action_19
action_14 (44) = happyShift action_20
action_14 (45) = happyShift action_27
action_14 (46) = happyShift action_22
action_14 (11) = happyGoto action_35
action_14 (12) = happyGoto action_10
action_14 (13) = happyGoto action_11
action_14 (14) = happyGoto action_12
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (21) = happyShift action_14
action_15 (26) = happyShift action_15
action_15 (27) = happyShift action_16
action_15 (30) = happyShift action_17
action_15 (31) = happyShift action_18
action_15 (42) = happyShift action_19
action_15 (44) = happyShift action_20
action_15 (45) = happyShift action_34
action_15 (46) = happyShift action_22
action_15 (6) = happyGoto action_31
action_15 (7) = happyGoto action_5
action_15 (8) = happyGoto action_6
action_15 (9) = happyGoto action_7
action_15 (10) = happyGoto action_8
action_15 (11) = happyGoto action_9
action_15 (12) = happyGoto action_10
action_15 (13) = happyGoto action_11
action_15 (14) = happyGoto action_12
action_15 (15) = happyGoto action_32
action_15 (16) = happyGoto action_33
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (21) = happyShift action_14
action_16 (26) = happyShift action_15
action_16 (27) = happyShift action_16
action_16 (30) = happyShift action_17
action_16 (31) = happyShift action_18
action_16 (42) = happyShift action_19
action_16 (44) = happyShift action_20
action_16 (45) = happyShift action_27
action_16 (46) = happyShift action_22
action_16 (6) = happyGoto action_29
action_16 (7) = happyGoto action_5
action_16 (8) = happyGoto action_6
action_16 (9) = happyGoto action_7
action_16 (10) = happyGoto action_8
action_16 (11) = happyGoto action_9
action_16 (12) = happyGoto action_10
action_16 (13) = happyGoto action_11
action_16 (14) = happyGoto action_12
action_16 (15) = happyGoto action_30
action_16 _ = happyFail (happyExpListPerState 16)

action_17 (21) = happyShift action_14
action_17 (26) = happyShift action_15
action_17 (27) = happyShift action_16
action_17 (30) = happyShift action_17
action_17 (31) = happyShift action_18
action_17 (42) = happyShift action_19
action_17 (44) = happyShift action_20
action_17 (45) = happyShift action_27
action_17 (46) = happyShift action_22
action_17 (11) = happyGoto action_28
action_17 (12) = happyGoto action_10
action_17 (13) = happyGoto action_11
action_17 (14) = happyGoto action_12
action_17 _ = happyFail (happyExpListPerState 17)

action_18 (21) = happyShift action_14
action_18 (26) = happyShift action_15
action_18 (27) = happyShift action_16
action_18 (30) = happyShift action_17
action_18 (31) = happyShift action_18
action_18 (42) = happyShift action_19
action_18 (44) = happyShift action_20
action_18 (45) = happyShift action_27
action_18 (46) = happyShift action_22
action_18 (11) = happyGoto action_26
action_18 (12) = happyGoto action_10
action_18 (13) = happyGoto action_11
action_18 (14) = happyGoto action_12
action_18 _ = happyFail (happyExpListPerState 18)

action_19 (44) = happyShift action_20
action_19 (46) = happyShift action_22
action_19 (14) = happyGoto action_25
action_19 _ = happyFail (happyExpListPerState 19)

action_20 _ = happyReduce_40

action_21 (19) = happyShift action_23
action_21 (26) = happyShift action_24
action_21 _ = happyReduce_36

action_22 _ = happyReduce_41

action_23 (21) = happyShift action_14
action_23 (26) = happyShift action_15
action_23 (27) = happyShift action_16
action_23 (30) = happyShift action_17
action_23 (31) = happyShift action_18
action_23 (42) = happyShift action_19
action_23 (44) = happyShift action_20
action_23 (45) = happyShift action_27
action_23 (46) = happyShift action_22
action_23 (6) = happyGoto action_77
action_23 (7) = happyGoto action_5
action_23 (8) = happyGoto action_6
action_23 (9) = happyGoto action_7
action_23 (10) = happyGoto action_8
action_23 (11) = happyGoto action_9
action_23 (12) = happyGoto action_10
action_23 (13) = happyGoto action_11
action_23 (14) = happyGoto action_12
action_23 _ = happyFail (happyExpListPerState 23)

action_24 (21) = happyShift action_14
action_24 (26) = happyShift action_15
action_24 (27) = happyShift action_16
action_24 (30) = happyShift action_17
action_24 (31) = happyShift action_18
action_24 (42) = happyShift action_19
action_24 (44) = happyShift action_20
action_24 (45) = happyShift action_27
action_24 (46) = happyShift action_22
action_24 (6) = happyGoto action_29
action_24 (7) = happyGoto action_5
action_24 (8) = happyGoto action_6
action_24 (9) = happyGoto action_7
action_24 (10) = happyGoto action_8
action_24 (11) = happyGoto action_9
action_24 (12) = happyGoto action_10
action_24 (13) = happyGoto action_11
action_24 (14) = happyGoto action_12
action_24 (15) = happyGoto action_76
action_24 _ = happyFail (happyExpListPerState 24)

action_25 _ = happyReduce_37

action_26 _ = happyReduce_25

action_27 (26) = happyShift action_24
action_27 _ = happyReduce_36

action_28 _ = happyReduce_27

action_29 _ = happyReduce_42

action_30 (28) = happyShift action_75
action_30 (29) = happyShift action_73
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (25) = happyShift action_74
action_31 _ = happyReduce_42

action_32 (25) = happyShift action_72
action_32 (29) = happyShift action_73
action_32 _ = happyFail (happyExpListPerState 32)

action_33 (25) = happyShift action_70
action_33 (41) = happyShift action_71
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (25) = happyReduce_44
action_34 (26) = happyShift action_24
action_34 (41) = happyReduce_44
action_34 _ = happyReduce_36

action_35 _ = happyReduce_26

action_36 (26) = happyShift action_69
action_36 _ = happyFail (happyExpListPerState 36)

action_37 _ = happyReduce_38

action_38 (26) = happyShift action_15
action_38 (27) = happyShift action_16
action_38 (42) = happyShift action_19
action_38 (44) = happyShift action_20
action_38 (45) = happyShift action_27
action_38 (46) = happyShift action_22
action_38 (12) = happyGoto action_68
action_38 (13) = happyGoto action_11
action_38 (14) = happyGoto action_12
action_38 _ = happyFail (happyExpListPerState 38)

action_39 (21) = happyShift action_14
action_39 (26) = happyShift action_15
action_39 (27) = happyShift action_16
action_39 (30) = happyShift action_17
action_39 (31) = happyShift action_18
action_39 (42) = happyShift action_19
action_39 (44) = happyShift action_20
action_39 (45) = happyShift action_27
action_39 (46) = happyShift action_22
action_39 (11) = happyGoto action_67
action_39 (12) = happyGoto action_10
action_39 (13) = happyGoto action_11
action_39 (14) = happyGoto action_12
action_39 _ = happyFail (happyExpListPerState 39)

action_40 (21) = happyShift action_14
action_40 (26) = happyShift action_15
action_40 (27) = happyShift action_16
action_40 (30) = happyShift action_17
action_40 (31) = happyShift action_18
action_40 (42) = happyShift action_19
action_40 (44) = happyShift action_20
action_40 (45) = happyShift action_27
action_40 (46) = happyShift action_22
action_40 (11) = happyGoto action_66
action_40 (12) = happyGoto action_10
action_40 (13) = happyGoto action_11
action_40 (14) = happyGoto action_12
action_40 _ = happyFail (happyExpListPerState 40)

action_41 (21) = happyShift action_14
action_41 (26) = happyShift action_15
action_41 (27) = happyShift action_16
action_41 (30) = happyShift action_17
action_41 (31) = happyShift action_18
action_41 (42) = happyShift action_19
action_41 (44) = happyShift action_20
action_41 (45) = happyShift action_27
action_41 (46) = happyShift action_22
action_41 (11) = happyGoto action_65
action_41 (12) = happyGoto action_10
action_41 (13) = happyGoto action_11
action_41 (14) = happyGoto action_12
action_41 _ = happyFail (happyExpListPerState 41)

action_42 (21) = happyShift action_14
action_42 (26) = happyShift action_15
action_42 (27) = happyShift action_16
action_42 (30) = happyShift action_17
action_42 (31) = happyShift action_18
action_42 (42) = happyShift action_19
action_42 (44) = happyShift action_20
action_42 (45) = happyShift action_27
action_42 (46) = happyShift action_22
action_42 (9) = happyGoto action_64
action_42 (10) = happyGoto action_8
action_42 (11) = happyGoto action_9
action_42 (12) = happyGoto action_10
action_42 (13) = happyGoto action_11
action_42 (14) = happyGoto action_12
action_42 _ = happyFail (happyExpListPerState 42)

action_43 (21) = happyShift action_14
action_43 (26) = happyShift action_15
action_43 (27) = happyShift action_16
action_43 (30) = happyShift action_17
action_43 (31) = happyShift action_18
action_43 (42) = happyShift action_19
action_43 (44) = happyShift action_20
action_43 (45) = happyShift action_27
action_43 (46) = happyShift action_22
action_43 (10) = happyGoto action_63
action_43 (11) = happyGoto action_9
action_43 (12) = happyGoto action_10
action_43 (13) = happyGoto action_11
action_43 (14) = happyGoto action_12
action_43 _ = happyFail (happyExpListPerState 43)

action_44 (21) = happyShift action_14
action_44 (26) = happyShift action_15
action_44 (27) = happyShift action_16
action_44 (30) = happyShift action_17
action_44 (31) = happyShift action_18
action_44 (42) = happyShift action_19
action_44 (44) = happyShift action_20
action_44 (45) = happyShift action_27
action_44 (46) = happyShift action_22
action_44 (10) = happyGoto action_62
action_44 (11) = happyGoto action_9
action_44 (12) = happyGoto action_10
action_44 (13) = happyGoto action_11
action_44 (14) = happyGoto action_12
action_44 _ = happyFail (happyExpListPerState 44)

action_45 (21) = happyShift action_14
action_45 (26) = happyShift action_15
action_45 (27) = happyShift action_16
action_45 (30) = happyShift action_17
action_45 (31) = happyShift action_18
action_45 (42) = happyShift action_19
action_45 (44) = happyShift action_20
action_45 (45) = happyShift action_27
action_45 (46) = happyShift action_22
action_45 (9) = happyGoto action_61
action_45 (10) = happyGoto action_8
action_45 (11) = happyGoto action_9
action_45 (12) = happyGoto action_10
action_45 (13) = happyGoto action_11
action_45 (14) = happyGoto action_12
action_45 _ = happyFail (happyExpListPerState 45)

action_46 (21) = happyShift action_14
action_46 (26) = happyShift action_15
action_46 (27) = happyShift action_16
action_46 (30) = happyShift action_17
action_46 (31) = happyShift action_18
action_46 (42) = happyShift action_19
action_46 (44) = happyShift action_20
action_46 (45) = happyShift action_27
action_46 (46) = happyShift action_22
action_46 (9) = happyGoto action_60
action_46 (10) = happyGoto action_8
action_46 (11) = happyGoto action_9
action_46 (12) = happyGoto action_10
action_46 (13) = happyGoto action_11
action_46 (14) = happyGoto action_12
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (21) = happyShift action_14
action_47 (26) = happyShift action_15
action_47 (27) = happyShift action_16
action_47 (30) = happyShift action_17
action_47 (31) = happyShift action_18
action_47 (42) = happyShift action_19
action_47 (44) = happyShift action_20
action_47 (45) = happyShift action_27
action_47 (46) = happyShift action_22
action_47 (9) = happyGoto action_59
action_47 (10) = happyGoto action_8
action_47 (11) = happyGoto action_9
action_47 (12) = happyGoto action_10
action_47 (13) = happyGoto action_11
action_47 (14) = happyGoto action_12
action_47 _ = happyFail (happyExpListPerState 47)

action_48 (21) = happyShift action_14
action_48 (26) = happyShift action_15
action_48 (27) = happyShift action_16
action_48 (30) = happyShift action_17
action_48 (31) = happyShift action_18
action_48 (42) = happyShift action_19
action_48 (44) = happyShift action_20
action_48 (45) = happyShift action_27
action_48 (46) = happyShift action_22
action_48 (9) = happyGoto action_58
action_48 (10) = happyGoto action_8
action_48 (11) = happyGoto action_9
action_48 (12) = happyGoto action_10
action_48 (13) = happyGoto action_11
action_48 (14) = happyGoto action_12
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (21) = happyShift action_14
action_49 (26) = happyShift action_15
action_49 (27) = happyShift action_16
action_49 (30) = happyShift action_17
action_49 (31) = happyShift action_18
action_49 (42) = happyShift action_19
action_49 (44) = happyShift action_20
action_49 (45) = happyShift action_27
action_49 (46) = happyShift action_22
action_49 (9) = happyGoto action_57
action_49 (10) = happyGoto action_8
action_49 (11) = happyGoto action_9
action_49 (12) = happyGoto action_10
action_49 (13) = happyGoto action_11
action_49 (14) = happyGoto action_12
action_49 _ = happyFail (happyExpListPerState 49)

action_50 (21) = happyShift action_14
action_50 (26) = happyShift action_15
action_50 (27) = happyShift action_16
action_50 (30) = happyShift action_17
action_50 (31) = happyShift action_18
action_50 (42) = happyShift action_19
action_50 (44) = happyShift action_20
action_50 (45) = happyShift action_27
action_50 (46) = happyShift action_22
action_50 (7) = happyGoto action_56
action_50 (8) = happyGoto action_6
action_50 (9) = happyGoto action_7
action_50 (10) = happyGoto action_8
action_50 (11) = happyGoto action_9
action_50 (12) = happyGoto action_10
action_50 (13) = happyGoto action_11
action_50 (14) = happyGoto action_12
action_50 _ = happyFail (happyExpListPerState 50)

action_51 (21) = happyShift action_14
action_51 (26) = happyShift action_15
action_51 (27) = happyShift action_16
action_51 (30) = happyShift action_17
action_51 (31) = happyShift action_18
action_51 (42) = happyShift action_19
action_51 (44) = happyShift action_20
action_51 (45) = happyShift action_27
action_51 (46) = happyShift action_22
action_51 (8) = happyGoto action_55
action_51 (9) = happyGoto action_7
action_51 (10) = happyGoto action_8
action_51 (11) = happyGoto action_9
action_51 (12) = happyGoto action_10
action_51 (13) = happyGoto action_11
action_51 (14) = happyGoto action_12
action_51 _ = happyFail (happyExpListPerState 51)

action_52 (21) = happyShift action_14
action_52 (26) = happyShift action_15
action_52 (27) = happyShift action_16
action_52 (30) = happyShift action_17
action_52 (31) = happyShift action_18
action_52 (42) = happyShift action_19
action_52 (44) = happyShift action_20
action_52 (45) = happyShift action_27
action_52 (46) = happyShift action_22
action_52 (8) = happyGoto action_54
action_52 (9) = happyGoto action_7
action_52 (10) = happyGoto action_8
action_52 (11) = happyGoto action_9
action_52 (12) = happyGoto action_10
action_52 (13) = happyGoto action_11
action_52 (14) = happyGoto action_12
action_52 _ = happyFail (happyExpListPerState 52)

action_53 _ = happyReduce_3

action_54 _ = happyReduce_9

action_55 _ = happyReduce_8

action_56 (20) = happyShift action_85
action_56 (22) = happyShift action_51
action_56 (23) = happyShift action_52
action_56 _ = happyFail (happyExpListPerState 56)

action_57 (30) = happyShift action_43
action_57 (31) = happyShift action_44
action_57 _ = happyReduce_15

action_58 (30) = happyShift action_43
action_58 (31) = happyShift action_44
action_58 _ = happyReduce_12

action_59 (30) = happyShift action_43
action_59 (31) = happyShift action_44
action_59 _ = happyReduce_11

action_60 (30) = happyShift action_43
action_60 (31) = happyShift action_44
action_60 _ = happyReduce_13

action_61 (30) = happyShift action_43
action_61 (31) = happyShift action_44
action_61 _ = happyReduce_14

action_62 (33) = happyShift action_39
action_62 (34) = happyShift action_40
action_62 (35) = happyShift action_41
action_62 _ = happyReduce_19

action_63 (33) = happyShift action_39
action_63 (34) = happyShift action_40
action_63 (35) = happyShift action_41
action_63 _ = happyReduce_18

action_64 (30) = happyShift action_43
action_64 (31) = happyShift action_44
action_64 _ = happyReduce_16

action_65 _ = happyReduce_23

action_66 _ = happyReduce_22

action_67 _ = happyReduce_21

action_68 _ = happyReduce_29

action_69 (45) = happyShift action_84
action_69 (5) = happyGoto action_83
action_69 _ = happyFail (happyExpListPerState 69)

action_70 (26) = happyShift action_82
action_70 _ = happyFail (happyExpListPerState 70)

action_71 (45) = happyShift action_81
action_71 _ = happyFail (happyExpListPerState 71)

action_72 _ = happyReduce_32

action_73 (21) = happyShift action_14
action_73 (26) = happyShift action_15
action_73 (27) = happyShift action_16
action_73 (30) = happyShift action_17
action_73 (31) = happyShift action_18
action_73 (42) = happyShift action_19
action_73 (44) = happyShift action_20
action_73 (45) = happyShift action_27
action_73 (46) = happyShift action_22
action_73 (6) = happyGoto action_80
action_73 (7) = happyGoto action_5
action_73 (8) = happyGoto action_6
action_73 (9) = happyGoto action_7
action_73 (10) = happyGoto action_8
action_73 (11) = happyGoto action_9
action_73 (12) = happyGoto action_10
action_73 (13) = happyGoto action_11
action_73 (14) = happyGoto action_12
action_73 _ = happyFail (happyExpListPerState 73)

action_74 _ = happyReduce_31

action_75 _ = happyReduce_34

action_76 (25) = happyShift action_79
action_76 (29) = happyShift action_73
action_76 _ = happyFail (happyExpListPerState 76)

action_77 (47) = happyShift action_78
action_77 _ = happyFail (happyExpListPerState 77)

action_78 _ = happyReduce_1

action_79 _ = happyReduce_35

action_80 _ = happyReduce_43

action_81 _ = happyReduce_45

action_82 (21) = happyShift action_14
action_82 (26) = happyShift action_15
action_82 (27) = happyShift action_16
action_82 (30) = happyShift action_17
action_82 (31) = happyShift action_18
action_82 (42) = happyShift action_19
action_82 (44) = happyShift action_20
action_82 (45) = happyShift action_27
action_82 (46) = happyShift action_22
action_82 (6) = happyGoto action_29
action_82 (7) = happyGoto action_5
action_82 (8) = happyGoto action_6
action_82 (9) = happyGoto action_7
action_82 (10) = happyGoto action_8
action_82 (11) = happyGoto action_9
action_82 (12) = happyGoto action_10
action_82 (13) = happyGoto action_11
action_82 (14) = happyGoto action_12
action_82 (15) = happyGoto action_89
action_82 _ = happyFail (happyExpListPerState 82)

action_83 (25) = happyShift action_87
action_83 (29) = happyShift action_88
action_83 _ = happyFail (happyExpListPerState 83)

action_84 _ = happyReduce_4

action_85 (21) = happyShift action_14
action_85 (26) = happyShift action_15
action_85 (27) = happyShift action_16
action_85 (30) = happyShift action_17
action_85 (31) = happyShift action_18
action_85 (42) = happyShift action_19
action_85 (44) = happyShift action_20
action_85 (45) = happyShift action_27
action_85 (46) = happyShift action_22
action_85 (6) = happyGoto action_86
action_85 (7) = happyGoto action_5
action_85 (8) = happyGoto action_6
action_85 (9) = happyGoto action_7
action_85 (10) = happyGoto action_8
action_85 (11) = happyGoto action_9
action_85 (12) = happyGoto action_10
action_85 (13) = happyGoto action_11
action_85 (14) = happyGoto action_12
action_85 _ = happyFail (happyExpListPerState 85)

action_86 _ = happyReduce_6

action_87 (19) = happyShift action_92
action_87 _ = happyFail (happyExpListPerState 87)

action_88 (45) = happyShift action_91
action_88 _ = happyFail (happyExpListPerState 88)

action_89 (25) = happyShift action_90
action_89 (29) = happyShift action_73
action_89 _ = happyFail (happyExpListPerState 89)

action_90 _ = happyReduce_33

action_91 _ = happyReduce_5

action_92 (21) = happyShift action_14
action_92 (26) = happyShift action_15
action_92 (27) = happyShift action_16
action_92 (30) = happyShift action_17
action_92 (31) = happyShift action_18
action_92 (42) = happyShift action_19
action_92 (44) = happyShift action_20
action_92 (45) = happyShift action_27
action_92 (46) = happyShift action_22
action_92 (6) = happyGoto action_93
action_92 (7) = happyGoto action_5
action_92 (8) = happyGoto action_6
action_92 (9) = happyGoto action_7
action_92 (10) = happyGoto action_8
action_92 (11) = happyGoto action_9
action_92 (12) = happyGoto action_10
action_92 (13) = happyGoto action_11
action_92 (14) = happyGoto action_12
action_92 _ = happyFail (happyExpListPerState 92)

action_93 (47) = happyShift action_94
action_93 _ = happyFail (happyExpListPerState 93)

action_94 _ = happyReduce_2

happyReduce_1 = happyReduce 4 4 happyReduction_1
happyReduction_1 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (IDENT happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (VariableAssignment happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_2 = happyReduce 8 4 happyReduction_2
happyReduction_2 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (IDENT happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (FunctionAssignment happy_var_2 happy_var_4 happy_var_7
	) `HappyStk` happyRest

happyReduce_3 = happySpecReduce_2  4 happyReduction_3
happyReduction_3 _
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn4
		 (PrintExpression happy_var_1
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  5 happyReduction_4
happyReduction_4 (HappyTerminal (IDENT happy_var_1))
	 =  HappyAbsSyn5
		 ([happy_var_1]
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_3  5 happyReduction_5
happyReduction_5 (HappyTerminal (IDENT happy_var_3))
	_
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_3 : happy_var_1
	)
happyReduction_5 _ _ _  = notHappyAtAll 

happyReduce_6 = happyReduce 5 6 happyReduction_6
happyReduction_6 ((HappyAbsSyn6  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (ForExpression happy_var_1 happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_7 = happySpecReduce_1  6 happyReduction_7
happyReduction_7 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn6
		 (Logical happy_var_1
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_3  7 happyReduction_8
happyReduction_8 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (And happy_var_1 happy_var_3
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  7 happyReduction_9
happyReduction_9 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (Or happy_var_1 happy_var_3
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  7 happyReduction_10
happyReduction_10 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn7
		 (Relational happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_3  8 happyReduction_11
happyReduction_11 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 (Less happy_var_1 happy_var_3
	)
happyReduction_11 _ _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  8 happyReduction_12
happyReduction_12 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 (Greater happy_var_1 happy_var_3
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  8 happyReduction_13
happyReduction_13 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 (LessOrEqual happy_var_1 happy_var_3
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_3  8 happyReduction_14
happyReduction_14 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 (GreaterOrEqual happy_var_1 happy_var_3
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_3  8 happyReduction_15
happyReduction_15 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 (NotEqual happy_var_1 happy_var_3
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_3  8 happyReduction_16
happyReduction_16 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 (Equal happy_var_1 happy_var_3
	)
happyReduction_16 _ _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  8 happyReduction_17
happyReduction_17 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 (Expr1 happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  9 happyReduction_18
happyReduction_18 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (Add happy_var_1 happy_var_3
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  9 happyReduction_19
happyReduction_19 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (Sub happy_var_1 happy_var_3
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_1  9 happyReduction_20
happyReduction_20 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 (Term happy_var_1
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  10 happyReduction_21
happyReduction_21 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Mult happy_var_1 happy_var_3
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  10 happyReduction_22
happyReduction_22 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Divide happy_var_1 happy_var_3
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_3  10 happyReduction_23
happyReduction_23 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (DotProduct happy_var_1 happy_var_3
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_1  10 happyReduction_24
happyReduction_24 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn10
		 (Unary happy_var_1
	)
happyReduction_24 _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_2  11 happyReduction_25
happyReduction_25 (HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (Neg happy_var_2
	)
happyReduction_25 _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_2  11 happyReduction_26
happyReduction_26 (HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (Not happy_var_2
	)
happyReduction_26 _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_2  11 happyReduction_27
happyReduction_27 (HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (Pos happy_var_2
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  11 happyReduction_28
happyReduction_28 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn11
		 (Power happy_var_1
	)
happyReduction_28 _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_3  12 happyReduction_29
happyReduction_29 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn12
		 (Exponent happy_var_1 happy_var_3
	)
happyReduction_29 _ _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  12 happyReduction_30
happyReduction_30 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn12
		 (Primary happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_3  13 happyReduction_31
happyReduction_31 _
	(HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn13
		 (ParExpression happy_var_2
	)
happyReduction_31 _ _ _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_3  13 happyReduction_32
happyReduction_32 _
	(HappyAbsSyn15  happy_var_2)
	_
	 =  HappyAbsSyn13
		 (Tuple happy_var_2
	)
happyReduction_32 _ _ _  = notHappyAtAll 

happyReduce_33 = happyReduce 6 13 happyReduction_33
happyReduction_33 (_ `HappyStk`
	(HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (FApp happy_var_2 happy_var_5
	) `HappyStk` happyRest

happyReduce_34 = happySpecReduce_3  13 happyReduction_34
happyReduction_34 _
	(HappyAbsSyn15  happy_var_2)
	_
	 =  HappyAbsSyn13
		 (Set happy_var_2
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happyReduce 4 13 happyReduction_35
happyReduction_35 (_ `HappyStk`
	(HappyAbsSyn15  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (IDENT happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (FCall happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_36 = happySpecReduce_1  13 happyReduction_36
happyReduction_36 (HappyTerminal (IDENT happy_var_1))
	 =  HappyAbsSyn13
		 (Identifier happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_2  13 happyReduction_37
happyReduction_37 (HappyAbsSyn14  happy_var_2)
	_
	 =  HappyAbsSyn13
		 (Dollar happy_var_2
	)
happyReduction_37 _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_2  13 happyReduction_38
happyReduction_38 _
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 (Percent happy_var_1
	)
happyReduction_38 _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_1  13 happyReduction_39
happyReduction_39 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 (Number happy_var_1
	)
happyReduction_39 _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_1  14 happyReduction_40
happyReduction_40 (HappyTerminal (INTEGER happy_var_1))
	 =  HappyAbsSyn14
		 (IntNode happy_var_1
	)
happyReduction_40 _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_1  14 happyReduction_41
happyReduction_41 (HappyTerminal (REAL happy_var_1))
	 =  HappyAbsSyn14
		 (RealNode happy_var_1
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_1  15 happyReduction_42
happyReduction_42 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn15
		 ([happy_var_1]
	)
happyReduction_42 _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_3  15 happyReduction_43
happyReduction_43 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_3 : happy_var_1
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_1  16 happyReduction_44
happyReduction_44 (HappyTerminal (IDENT happy_var_1))
	 =  HappyAbsSyn5
		 ([happy_var_1]
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  16 happyReduction_45
happyReduction_45 (HappyTerminal (IDENT happy_var_3))
	_
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_3 : happy_var_1
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 48 48 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	FOR -> cont 17;
	FUNC -> cont 18;
	IS -> cont 19;
	ELSE -> cont 20;
	NOT -> cont 21;
	AND -> cont 22;
	OR -> cont 23;
	EQUALS -> cont 24;
	RPAR -> cont 25;
	LPAR -> cont 26;
	LCURL -> cont 27;
	RCURL -> cont 28;
	COMMA -> cont 29;
	POSITIVE -> cont 30;
	NEGATIVE -> cont 31;
	CARROT -> cont 32;
	ASTRIX -> cont 33;
	SLASH -> cont 34;
	DOT -> cont 35;
	GEQ -> cont 36;
	LEQ -> cont 37;
	LTAN -> cont 38;
	GTAN -> cont 39;
	NE -> cont 40;
	OF -> cont 41;
	DOLLAR -> cont 42;
	PERCENT -> cont 43;
	INTEGER happy_dollar_dollar -> cont 44;
	IDENT happy_dollar_dollar -> cont 45;
	REAL happy_dollar_dollar -> cont 46;
	NEWLINE -> cont 47;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 48 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = HappyIdentity
    (<*>) = ap
instance Monad HappyIdentity where
    return = pure
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (return)
happyThen1 m k tks = (>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (return) a
happyError' :: () => ([(Token)], [String]) -> HappyIdentity a
happyError' = HappyIdentity . (\(tokens, _) -> parseError tokens)
parseAst tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


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
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}
{-# LINE 8 "<command-line>" #-}
# 1 "/usr/include/stdc-predef.h" 1 3 4

# 17 "/usr/include/stdc-predef.h" 3 4














































{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "/usr/lib/ghc/include/ghcversion.h" #-}

















{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "/tmp/ghc8814_0/ghc_2.h" #-}




























































































































































{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 









{-# LINE 43 "templates/GenericTemplate.hs" #-}

data Happy_IntList = HappyCons Int Happy_IntList







{-# LINE 65 "templates/GenericTemplate.hs" #-}

{-# LINE 75 "templates/GenericTemplate.hs" #-}

{-# LINE 84 "templates/GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 137 "templates/GenericTemplate.hs" #-}

{-# LINE 147 "templates/GenericTemplate.hs" #-}
indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x < y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `div` 16)) (bit `mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 267 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 333 "templates/GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
