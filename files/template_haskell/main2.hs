module Main where
import Printf1

errorVar :: String -> String -> String
errorVar msg var = $(printf "Error %s with variable %s") msg var

main = putStrLn (errorVar "Undeclared variable" "fo")