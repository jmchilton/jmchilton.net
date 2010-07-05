module Main where
import Sel

-- Defines procedures sel1of7, sel2of7, ..., sel7of7
$(gen_sels 7)

main = putStrLn (sel4of7 (1,"b",3,"d",sqrt,"f",[1,2]))