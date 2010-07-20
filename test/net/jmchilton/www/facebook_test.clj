(ns net.jmchilton.www.facebook-test
  (:use clojure.test
        clojure.xml  
        (net.jmchilton.www facebook xml)))

(defn valid-item? [item]
  (and (contains? item :description)
       (contains? item :link)
       (contains? item :date)
       (= (:source item) :facebook)))
         
(deftest test-rss-parsing
  (let [xml (parse-xml (slurp "resources/facebook.rss"))
        items (parse-items xml)]
    (every? valid-item? items)))
