module Sel where
import Language.Haskell.TH;
import Language.Haskell.TH.Syntax;



-- Produce ExpQ for \(a1,a2,...,an) -> am
-- Reminder: lamE :: [PatQ] -> ExpQ -> ExpQ
sel :: Int -> Int -> ExpQ
sel i n =
  let as :: [Name]
      as = map mkName ["a"++show i | i <- [1..n] ]
      -- as = [a1, a2, ..., an]

      pat :: PatQ
      pat = tupP (map varP as)
  in lamE [pat] (varE (as !! (i-1))) -- !! is 0 indexed







gen_sels :: Int -> Q [Dec]
gen_sels m =
  let names :: [String]
      names = ["sel"++show i++"of"++show m | i <- [1..m]]

      buildBinding :: Int -> DecQ
      buildBinding i = (valD (varP (mkName (names !! (i-1)))) 
                             (normalB (sel i m)) 
                             [])

  -- sequence :: [Q Dec] -> Q [Dec] 
  in sequence (map buildBinding [1..m])













