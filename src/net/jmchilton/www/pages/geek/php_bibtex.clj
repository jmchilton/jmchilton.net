(list
  [:p "Here is some code PHP code I threw together for working with "
     "BibTeX files. This code is based a large part on code I found "
     [:a {"href" "http://www.chaaban.info/wordpress-plugin/bibtex/"} "here"]
     ". The code will parse and read BibTeX (.bib) files and has a "
     "mechanism for producing an html/css formatted version of the BibTeX "
     "file as well as a mechanism to create and embed citations in other php files."]
  (vec
    (cons :ul
	    (map
	      (fn [url text]
	        [:li [:a {"href" url} text]])
    	  (list "files/bibtex_php.tgz")
		    ;"files/bibtex_php/sample.php"
		    ;"files/bibtex_php/bibtex_db.php"
	      (list "php files with sample" )))))
		    ;"Citation Example" 
		    ;"HTML Formatted BibTeX"))))