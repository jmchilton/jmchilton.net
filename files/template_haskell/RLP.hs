
module RLP where
import Language.Haskell.TH
import Random
import GHC.Float

randomUniform01 :: IO Double
randomUniform01 = (getStdRandom (randomR (0,10000))) >>= (return . (/ 10000.0) . fromInteger)

-------------------------
-- RLP Expression Data --
-------------------------
data RLPExpr = RLPAddE RLPExpr RLPExpr
             | RLPMultE RLPExpr RLPExpr
             | RLPVarE Name
             | RLPPertubationE 
             | RLPConstE Double 

-- Showing RLP Expression Data
showRL :: RLPExpr -> String
showRL (RLPAddE x y) = "(" ++ (show x) ++ " + " ++ (show y) ++ ")"
showRL (RLPMultE x y) = "(" ++ (show x) ++ " * " ++ (show y) ++ ")"
showRL (RLPVarE x) = show x 
showRL (RLPConstE x) = show x
showRL (RLPPertubationE) = "e"

instance Show RLPExpr where
    show = showRL


mkBinOpExp :: String -> (Exp -> Exp -> Exp)
mkBinOpExp op = \ e1 e2 -> (InfixE (Just e1) (varNameE op) (Just e2))

addExp  = mkBinOpExp "+"
multExp = mkBinOpExp "*"
eqExp   = mkBinOpExp "=="

varNameE = VarE . mkName
varNameP = VarP . mkName

exprToRLPExpr :: Exp -> RLPExpr
exprToRLPExpr (InfixE (Just x) (VarE op) (Just y)) 
    | name == "*" = RLPMultE (exprToRLPExpr x) (exprToRLPExpr y)
    | name == "+" = RLPAddE  (exprToRLPExpr x) (exprToRLPExpr y)
    where name = nameBase op
exprToRLPExpr (VarE x) = RLPVarE x
exprToRLPExpr (LitE (IntegerL x)) = RLPConstE $ fromInteger x 
exprToRLPExpr (LitE (RationalL x)) = RLPConstE $ fromRational x
exprToRLPExpr (LitE (DoublePrimL x)) = RLPConstE $ fromRational x

randomizedVar :: Name -> Name
randomizedVar name = mkName ((nameBase name)++"Rand")

randomizeExpr :: RLPExpr -> RLPExpr
randomizeExpr (RLPAddE x y) = (RLPAddE (randomizeExpr x) (randomizeExpr y))
randomizeExpr (RLPMultE x y) = (RLPMultE (randomizeExpr x) (randomizeExpr y))
randomizeExpr var@(RLPVarE x) = (RLPAddE var (RLPMultE (RLPVarE $ randomizedVar x) (RLPPertubationE)))
randomizeExpr x = x

extractVars :: RLPExpr -> [Name]
extractVars e = foldl (\ x y -> if elem y x then x else y:x) [] $ extractVars_ e
    where
      extractVars_ (RLPMultE x y) = (extractVars_ x) ++ (extractVars_ y)
      extractVars_ (RLPAddE x y)  = (extractVars_ x) ++ (extractVars_ y)
      extractVars_ (RLPVarE x)  = [x] 
      extractVars_ x = []


distribute :: RLPExpr -> RLPExpr
distribute expr = if isDistributed expr then expr else distribute $ distribute_ expr
    where
      distribute_ :: RLPExpr -> RLPExpr
      distribute_ (RLPMultE (RLPAddE x y) z) = RLPAddE 
                                               (RLPMultE (distribute x) (distribute z)) 
                                               (RLPMultE (distribute y) (distribute z))
      distribute_ (RLPMultE z (RLPAddE x y)) = RLPAddE 
                                               (RLPMultE (distribute z) (distribute x)) 
                                               (RLPMultE (distribute z) (distribute y))
      distribute_ (RLPMultE x y) = RLPMultE (distribute x) (distribute y)
      distribute_ (RLPAddE x y)  = RLPAddE (distribute x) (distribute y)
      distribute_ x = x

      isDistributed :: RLPExpr -> Bool
      isDistributed (RLPMultE (RLPAddE _ _) _) = False
      isDistributed (RLPMultE _ (RLPAddE _ _)) = False
      isDistributed (RLPMultE x y) = (isDistributed x) && (isDistributed y)
      isDistributed (RLPAddE x y) = (isDistributed x) && (isDistributed y)
      isDistributed _ = True


-- Groups terms into levels based on degree of Pertubation factor,
-- also filters out RLPPertubation factors.
rlpExprToTermListLevels :: RLPExpr -> [[[RLPExpr]]]
rlpExprToTermListLevels expr = map grab degreeLevels
    where 
      termList = rlpExprToTermList expr

      degreeTerm :: RLPExpr -> Int
      degreeTerm (RLPPertubationE) = 1
      degreeTerm x = 0
      
      rlpExprDegree :: [RLPExpr] -> Int
      rlpExprDegree explist = sum (map degreeTerm explist) 

      degreeLevels :: [Int]
      degreeLevels = let degrees = map rlpExprDegree termList
                     in  filter (`elem` degrees) [0 .. (maximum degrees)]
      
      grab :: Int -> [[RLPExpr]]
      grab deg = map (\t -> (filter (\e -> degreeTerm e == 0) t))
                 (filter (\e -> deg == (rlpExprDegree e)) termList)


rlpExprToTermList :: RLPExpr -> [[RLPExpr]]
rlpExprToTermList (RLPAddE x y) = (rlpExprToTermList x) ++ (rlpExprToTermList y)
rlpExprToTermList mul@(RLPMultE x y) = [(rlpMultToFactorList mul)]
rlpExprToTermList x = [[x]]
                            
rlpMultToFactorList :: RLPExpr -> [RLPExpr]
rlpMultToFactorList (RLPMultE x y) = (rlpMultToFactorList x) ++ (rlpMultToFactorList y)
rlpMultToFactorList x = [x]

factorListToRLPExpr :: [RLPExpr] -> RLPExpr
factorListToRLPExpr [car] = car
factorListToRLPExpr (car : cdr) = RLPMultE car (factorListToRLPExpr cdr) 

termListToRLPExpr :: [[RLPExpr]] -> RLPExpr
termListToRLPExpr [car] = factorListToRLPExpr car
termListToRLPExpr (car : cdr) = RLPAddE (factorListToRLPExpr car) (termListToRLPExpr cdr)





expandRLP :: RLPExpr -> RLPExpr
expandRLP = distribute . randomizeExpr

factorListToExp :: [RLPExpr] -> Exp
factorListToExp [x] = factorToExp x
factorListToExp (car : cdr) =  (multExp (factorToExp car) (factorListToExp cdr))

factorToExp :: RLPExpr -> Exp 
factorToExp (RLPVarE x) = VarE x
factorToExp (RLPConstE x) = (LitE (DoublePrimL $ toRational x))

termListToExp :: [[RLPExpr]] -> Exp
termListToExp [x] = factorListToExp x
termListToExp (car : cdr) = (addExp (factorListToExp car) (termListToExp cdr))

buildRLPExp :: RLPExpr -> Exp
buildRLPExp x = (DoE ((map bind (extractVars x)) ++ [(NoBindS returnE)]))
    where
      returnE = (AppE (varNameE "return") bodyE)
      bodyE = buildRLPBody $ rlpExprToTermListLevels $ expandRLP $ x
      bind name = (BindS (VarP $ randomizedVar name) (varNameE "randomUniform01"))
      
buildRLPBody :: [[[RLPExpr]]] -> Exp
buildRLPBody [] = LitE $ RationalL $ 0.0
buildRLPBody (car : cdr) = 
    (LetE [(ValD (varNameP "r") (NormalB $ termListToExp car) [])]
     (CondE (AppE (varNameE "not") (eqExp (varNameE "r") (LitE (RationalL 0.0))))
      (varNameE "r")
      (buildRLPBody cdr)))

rlpTransform :: Q Exp -> Q Exp
rlpTransform ast = runQ ast >>= return . buildRLPExp . exprToRLPExpr

-------------------
-- Testing Procs --
-------------------
printInfo :: Info -> IO String
printInfo x = return (pprint x)

printRL :: Q Exp -> IO ()
printRL ast = runQ ast >>= putStrLn . pprint . buildRLPExp . exprToRLPExpr

printCode :: Q Exp -> IO ()
printCode ast = runQ ast >>= putStrLn . pprint

printAST :: Q Exp -> IO ()
printAST ast = runQ ast >>= putStrLn . show

printDec :: Q [Dec] -> IO ()
printDec dec = runQ dec >>= putStrLn . show

printType :: Q Type -> IO ()
printType t = runQ t >>= putStrLn . show

