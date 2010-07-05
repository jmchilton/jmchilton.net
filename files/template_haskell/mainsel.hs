module Main where
import Sel

--main = putStrLn (show ($(sel 3 5) ("a","b","c","d","e")))

$(gen_sels 7)


main = putStrLn (show (sel4of7 ("a","b","c","d","e","f","g")))