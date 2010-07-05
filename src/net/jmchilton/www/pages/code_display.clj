(use '(net.jmchilton.www io id source))

(let [source-content-id (:source (:params net.jmchilton.www.page/*request*))]
  (if (valid-source-content-id? source-content-id)
      (list
        [:p "Source code for " (content-id->path source-content-id)]
        [:div {"class" "code"} (get-highlighted-source (content-id->path source-content-id))])
      [:p "Unknown or invalid source file specified - " source-content-id "."]))
