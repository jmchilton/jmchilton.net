(defn f07li [num]
  (let [rec "files/school/csci4011-F06/"
        pres (str rec "presentation/recitation_"  num ".")
        hand (str rec "handout/recitation_" num ".")
        link (fn [base ext] [:a {"href" (str base ext)} ext])]
     [:li 
       "Recitation " num
	     [:br]
	     "Presentation [" 
       (link pres "pdf") 
       "] [" 
       (link pres "ps") 
       "] [" 
       (link pres "tex") "]"
	     [:br]
	     "Handout [" 
       (link hand "pdf") 
       "] [" 
       (link hand "ps") 
       "] ["
       (link hand "tex") 
       "]"]))
	   

(list
  [:p "Welcome to a collection of my files related to the course on the "
      "Theory of Computation (CSCI 4011) that I was teaching assistant for at "
      "the University of Minnesota. If you would like to download and compile "
      "the LaTeX source files provided you will need " 
      [:a {"href" "files/school/csci4011-F06/latex-helpers.tar.gz"} "these"] "
      additional files"]
  [:h2 "Summer 2007 Files"]
  [:ul
    [:li 
      [:p [:a {"href" "files/school/csci4011-SU07/rec_1.pdf"} "Recitation 1 Handout"]
          " [PDF]"]]
    [:li 
      [:p [:a {"href" "files/school/csci4011-SU07/rec_2.pdf"} "Recitation 2 Handout"]
          " [PDF]"]]
    [:li
      [:p [:a {"href" "files/school/csci4011-SU07/rec_3.pdf"} "Recitation 3 Handout"]
          " [PDF]"]]
    [:li
      [:p [:a {"href" "files/school/csci4011-SU07/rec_4.pdf"} "Recitation 4 Handout"]
          " [PDF]"]]
    [:li
      [:p [:a {"href" "files/school/csci4011-SU07/rec_5.pdf"} "Recitation 5 Handout"]
          " [PDF]"]]
    [:li
      [:p [:a {"href" "files/school/csci4011-SU07/rec_6.pdf"} "Recitation 6 Handout"]
          " [PDF]"]]
    [:li
      [:p [:a {"href" "files/school/csci4011-SU07/rec_7.pdf"} "Recitation 7 Handout"]
          " [PDF]"]]
    [:li
      [:p [:a {"href" "files/school/csci4011-SU07/rec_8.pdf"} "Recitation 8 Handout"]
       " [PDF]"]]]
  [:h2 "Fall 2006 Files"]
  (vec (cons :ul (map f07li (range 1 16)))))