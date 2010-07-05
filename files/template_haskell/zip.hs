genPE :: String -> Int -> ([PatQ],[ExpQ])
genPE s n = 
  let ns = map mkName [ s++(show i) | i <- [1..n]]
  in (map varP ns, map varE ns)


apps :: [ExpQ] -> ExpQ
apps [x] = x
apps (x:y:zs) = apps ( [| $(x) $(y) |] : zs )




zipN :: Int -> ExpQ
zipN n = 
  let (pXs, eXs)  = genPE "x" n
      (pXSs,eXSs) = genPE "xs" n
      zp = mkName "zp"
      pcons (x, xs) = infixP x (mkName ":") xs
      pat = (map pcons (zip pXs pXSs))
      body = [| $(tupE eXs) : $(apps ((varE zp) : eXSs)) |]
  in 
    letE [funD zp 
               [clause pat                   (normalB body)     []
               ,clause [wildP | i <- [1..n]] (normalB [| [] |]) []
               ]
         ]
         (varE zp)


-- > zip3 [1,2,3,4] [4,5,6,7] [7,8,9,10]
-- [(1,4,7), (2,5,8), (3,6,9), (4,7,10)]


-- let zp (x1:x1s) (x2:x2s) (x3:x3s) 
--        = (x1,x2,x3) : (zp x1s x2s x3s)
--     zp _ _ _ = []
-- in zp
