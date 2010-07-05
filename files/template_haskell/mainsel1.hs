module Main where
import Sel

main = putStrLn ($(sel 4 7) ("a","b","c","d","e","f","g"))
