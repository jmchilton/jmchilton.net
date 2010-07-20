(ns net.jmchilton.www.foursquare-test
  (:use clojure.test
        clojure.xml  
        (net.jmchilton.www foursquare xml)))

(defn valid-item? [item]
  (and (contains? item :description)
       (contains? item :link)
       (contains? item :date)
       (= (:source item) :foursquare)))
         
(deftest test-rss-parsing
  (let [xml (parse-xml (slurp "resources/foursquare.rss"))
        items (parse-items xml)]
    (every? valid-item? items)))
