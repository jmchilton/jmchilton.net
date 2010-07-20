(ns net.jmchilton.www.flixster-test
  (:use clojure.test
        clojure.xml  
        (net.jmchilton.www flixster xml)))

(defn valid-item? [item]
  (and (contains? item :description)
       (contains? item :link)
       (contains? item :date)
       (= (:source item) :flixster)))
         
(deftest test-rss-parsing
  (let [xml (parse-xml (slurp "resources/ratings.rss"))
        items (parse-items xml)]
    (every? valid-item? items)))
