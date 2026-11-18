
module Main where

import Lexer
import Parser
import AST
import IR
import CodeGen
import qualified Data.Map as Map
import           Control.Monad.State (State)
import qualified Control.Monad.State as State

-- starting values for temporary and label counters
initialSupply :: Supply
initialSupply = (0, 0)

-- run a code generation action with initial supply
runCodeGen :: State Supply [Instr] -> [Instr]
runCodeGen gen = State.evalState gen initialSupply

main :: IO ()
main = do
  txt <- getContents
  print (parser $ alexScanTokens txt)
  line
  printIR (runCodeGen (transProg (parser $ alexScanTokens txt)))

-- print a list of IR instructions
printIR :: [Instr] -> IO ()
printIR = mapM_ print

-- print an horizontal line
line :: IO () 
line = putStrLn (replicate 40 '-')