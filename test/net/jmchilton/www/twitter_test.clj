(ns net.jmchilton.www.twitter-test
  (:use clojure.test
        clojure.xml  
        (net.jmchilton.www twitter xml)))

(defn valid-item? [item]
  (and (contains? item :description)
       (contains? item :link)
       (contains? item :date)
       (= (:source item) :twitter)))
         
(deftest test-rss-parsing
  (let [xml (parse-xml (slurp "resources/twitter2.rss"))
        items (parse-items xml)]
    (every? valid-item? items)))

(deftest test-rss
  (get-parsed-twitter-rss))