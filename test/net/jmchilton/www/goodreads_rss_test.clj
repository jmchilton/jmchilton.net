(ns net.jmchilton.www.goodreads-rss-test
  (:use clojure.test
        clojure.xml  
        (net.jmchilton.www goodreads-rss xml)))

(defn valid-item? [item]
  (and (contains? item :description)
       (contains? item :link)
       (contains? item :date)
       (= (:source item) :goodreads)))
         
(deftest test-rss-parsing
  (let [xml (parse-xml (slurp "resources/goodreads.rss"))
        items (parse-items xml)]
    (every? valid-item? items)))
