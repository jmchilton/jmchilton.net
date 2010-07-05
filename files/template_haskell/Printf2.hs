module Printf2 where
import Language.Haskell.TH;
import Language.Haskell.TH.Syntax;

-- parse :: String -> [Format]
-- gen :: [Format] -> Expr -> Expr
data Format = D | S | L String

printf :: String -> ExpQ
printf s = gen (parse s) (litE (StringL ""))

concatE :: ExpQ -> ExpQ -> ExpQ
concatE leftExp rightExp = 
  infixE (Just leftExp) (varE (mkName "++")) (Just rightExp)

showE :: ExpQ -> ExpQ
showE e = appE (varE (mkName "show")) e

gen [] x = x

gen (D : xs) x =
  do { n <- qNewName "n";
       let body = concatE x (showE (varE n)) 
       in lamE [varP n] (gen xs body) }

gen (S : xs) x =
  do { s <- qNewName "s";
       let body = concatE x (varE s)
       in lamE [varP s] (gen xs body) }

gen (L str : xs) x = 
  let body = concatE x (lift str)
  in gen xs body


-- Parses string into list of Format elements 
parse :: String -> [Format]
parse s = parse_ s ""
  where
    parse_ :: String -> String -> [Format]
    parse_ "" partial = addPartial partial
    parse_ ('%' : 'd' : cs) partial = (addPartial partial) ++ 
                                       [D] ++ (parse_ cs "")
    parse_ ('%' : 's' : cs) partial = (addPartial partial) ++
                                       [S] ++ (parse_ cs "")
    parse_ (c : cs) partial = parse_ cs (partial++[c])

    addPartial :: String -> [Format]
    addPartial "" = []
    addPartial cs = [L cs]

