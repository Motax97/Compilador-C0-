module Main where

import Lexer
import Parser

main :: IO ()
main = do
  txt <- getContents
  --print (alexScanTokens txt)
  print (parser $ alexScanTokens txt)