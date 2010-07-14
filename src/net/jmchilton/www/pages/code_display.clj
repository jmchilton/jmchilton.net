(use '(net.jmchilton.www io id source context xml))

(let [source-content-id (:source (:params *request*))]
  (if (valid-source-content-id? source-content-id)
      (list
        [:p "Source code for " (content-id->path source-content-id)]
        [:div {"class" "code"} 
          (get-source-markup (content-id->path source-content-id))])
      [:p "Unknown or invalid source file specified - " (escape-xml source-content-id) "."]))
