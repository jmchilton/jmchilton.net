(list
  [:p "Here are some files I used for a presentation on Template Haskell. "]

  (vec 
    (cons :ul
      (map 
        (fn [file]
		      [:li [:a {"href" (str "files/template_haskell/" file)} file]])
	      (list "haskell.hs" "main2.hs"  "mainrlp.hs" "mainsel.hs" 
		          "Printf3.hs" "zip.hs" "haskell-monad.hs"  "main3.hs"  
		          "mainsel1.hs" "Printf1.hs"  "RLP.hs"
		          "main1.hs" "main4.hs"  "mainsel2.hs"  
		          "Printf2.hs"  "Sel.hs" "th.pdf" "th.tex")))))


