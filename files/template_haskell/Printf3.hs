module Printf3 where
import Language.Haskell.TH;
import Language.Haskell.TH.Syntax;

printf :: String -> ExpQ
printf s = gen (parse s) [| "" |]

-- parse :: String -> [Format]
-- gen :: [Format] -> Expr -> Expr
data Format = D | S | L String

gen [] x = x
gen (D : xs) x = [| \n-> $(gen xs [| $(x)++show n |]) |]
gen (S : xs) x = [| \s-> $(gen xs [| $(x)++s |]) |]
gen (L s : xs) x = gen xs [| $(x) ++ $(lift s) |]


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

















