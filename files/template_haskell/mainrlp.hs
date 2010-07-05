module Main where
import Random
import GHC.Float
import RLP
import Language.Haskell.TH
import Language.Haskell.TH.Syntax

func :: Double -> Double -> Double -> IO Double 
func x y z = $(rlpTransform [| x + y * z |])

main = do { ans <- (func (2.0) -2.0 -1.0);
            putStrLn (show ans)
          }