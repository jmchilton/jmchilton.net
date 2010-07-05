(list
  [:p "The clojure scripts which run in a Jetty server instance that "
      "generate the pages of this website are meant to be completely open "
      "source. Each page contains a link at the bottom of the page that can be "
      "used to view the source code that generated that particular page. "
      "These pages are served up by this " 
      (net.jmchilton.www.page/view-source-link ":src:net:jmchilton:www:site.clj" "Ring script")
      ", which in return executes " (net.jmchilton.www.page/view-source-link ":src:net:jmchilton:www:page" "this script")
      " which contains most of the generic page logic."
   ]
   "All scripts not serving up specific content:"
   [:ul 
     [:li (net.jmchilton.www.page/view-source-link ":src:net:jmchilton:www:site.clj" "site.clj")]
     [:li (net.jmchilton.www.page/view-source-link ":htdocs:jpage" "jpage.scm")]
     [:li (net.jmchilton.www.page/view-source-link ":htdocs:jpage_utils" "jpage_utils.scm")]])