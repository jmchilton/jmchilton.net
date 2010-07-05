module Main where
import Printf1

errorAt :: String -> Int -> String
errorAt msg line = $(printf "Error: %s on line %d") msg line

main = putStrLn (errorAt "Undeclared variable" 314) 
