(ns net.jmchilton.www.blog-test
  (:use clojure.test
        clojure.xml  
        (net.jmchilton.www blog xml)))

(defn valid-item? [item]
  (and (contains? item :description)
       (contains? item :link)
       (contains? item :date)
       (= (:source item) :blog)))
         
(deftest test-rss-parsing
  (let [xml (parse-xml (slurp "resources/blog.rss"))
        items (parse-items xml)]
    (every? valid-item? items)))
