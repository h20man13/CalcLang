module Main where

import Lexer
import Parser
import Interpreter
import System.IO

runConsole :: VTable -> FTable -> IO ()
runConsole vT fT = do
                   putStr "CalcLang> ";
                   hFlush stdout;
                   line  <- getLine;
                   case line of
                     "" -> runConsole vT fT
                     ":Help" -> do
                                handle <- openFile "Help.txt" ReadMode
                                contents <- hGetContents handle
                                putStrLn contents
                                (runConsole vT fT)
                     ":Quit" -> putStrLn "Exited Program Successfully!!!"
                     line -> do
                             let tokens = (genTokens (line ++ "\n"))
                             let ast = (parseAst tokens)
                             (nVT, nFT) <- (interpret ast vT fT)
                             (runConsole nVT nFT)
                            
                            
                   
main :: IO ()
main = do
       let vT = SymbolTable []
       let fT = SymbolTable []
       runConsole vT fT
