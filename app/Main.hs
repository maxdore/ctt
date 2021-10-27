module Main where

import ErrM
import Lib
import LexCTT
import ParCTT
import PrintCTT
import AbsCTT
import LayoutCTT


import System.IO ( stdin, hGetContents )
import System.Environment ( getArgs, getProgName )
import System.Exit ( exitFailure, exitSuccess )
import Control.Monad ( when )

import System.Console.Haskeline
-- import System.Console.Haskeline.History


type ParseFun a = [Token] -> Err a


runFile :: ParseFun Module -> FilePath -> IO ()
runFile p f = putStrLn f >> readFile f >>= run p

run :: ParseFun Module -> String -> IO ()
run p s = let ts = (resolveLayout True . myLexer) s in case p ts of
           Bad s    -> do putStrLn "\nParse Failed...\n"
                          putStrLn "Tokens:"
                          putStrLn $ show ts
                          putStrLn s
                          exitFailure
           Ok  tree -> do
                          putStrLn "\n Input:"
                          putStrLn $ printTree tree
                          -- putStrLn "\nParse Successful!"
                          showTree tree
                          exitSuccess

showTree :: (Show a, Print a) => a -> IO ()
showTree tree
 = do
      putStrLn $ "\n[Abstract Syntax]\n\n" ++ show tree



replUsage :: InputT IO ()
replUsage = do
  outputStrLn $ unlines
    [ "This is the interactive environment for CTT! You can do the following:"
    , "  (term)          Get type and normal form"
    , "  :q              Quit the environment"
    , "  :h              Show this message"
    , "  :l              TODO"
    ]

repl :: InputT IO ()
repl = do
    minput <- getInputLine "CTT> "
    case minput of
        Nothing -> return ()
        Just ":q" -> return ()
        Just ":h" -> replUsage >> repl
        Just input -> do outputStrLn $ "Input was: " ++ input
                         repl

usage :: IO ()
usage = do
  putStrLn $ unlines
    [ "usage: Call with one of the following argument combinations:"
    , "  --help          Display this help message."
    , "  (no arguments)  Start REPL"
    , "  (file)          Check file."
    ]
  exitFailure

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["--help"] -> usage
    [] -> runInputT defaultSettings (replUsage >> repl)
    fs -> mapM_ (runFile pModule) fs

