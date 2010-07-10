; Ring Configuration for jmchilton.net
(ns net.jmchilton.www.site
  (:use (ring.handler dump)
        (ring.middleware stacktrace file-info file reload keyword-params params)
        (ring.adapter jetty)
        (net.jmchilton.www dispatch)
        (clojure.contrib except)))

;; Build a list of all net.jmchilton.www packages but exclude launch
;; to prevent the web server from restarting.
(def local-packages 
  (filter 
    (fn [symbol] 
      (let [name (.getName symbol)]  
           (and (.startsWith name "net.jmchilton.www") 
                (not 
                  (or (= name "net.jmchilton.www.cache")
                      (= name "net.jmchilton.www.launch")
                      (= name "net.jmchilton.www.site"))))))
    (map ns-name (all-ns))))

(def site
  (-> #'handler
      (wrap-keyword-params)
      (wrap-params)
      (wrap-stacktrace)
      (wrap-file-info)
      (wrap-file ".")
      (wrap-reload local-packages)))
