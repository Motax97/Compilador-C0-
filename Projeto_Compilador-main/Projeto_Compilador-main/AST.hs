
module AST where

data Exp = Num Int
        | Bool Bool
        | Var String
        | String String
        | Array String Exp

        | Add Exp Exp
        | Sub Exp Exp 
        | Mult Exp Exp 
        | Div Exp Exp 
        | Mod Exp Exp
        | Incr Exp
        | Decr Exp

        | Program [Exp]
        | Block [Exp] [Exp]

        | Decl Type [Exp]

        | Assign Exp Exp

        | If Exp Exp
        | IfElse Exp Exp Exp
        | While Exp Exp
        | For Exp Exp Exp Exp

        | Equal Exp Exp
        | Diff Exp Exp
        | Less Exp Exp
        | LessEq Exp Exp
        | Greater Exp Exp
        | GreaterEq Exp Exp
        | Or Exp Exp
        | And Exp Exp
        | Not Exp

        | Func Type String Exp Exp
        | Args [Exp]
        | Arg Type String
        | ArgArr Type String Int

        | FuncCall String [Exp]
        | FuncCallNoArg String
        | Return Exp

        | PrintI Exp
        | PrintS Exp
        | Scan
        deriving Show

data Type = TyInt
          | TyBool
          | TyString
          deriving Show