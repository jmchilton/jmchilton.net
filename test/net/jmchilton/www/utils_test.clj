(ns net.jmchilton.www.utils-test
  (:use 
    clojure.test
    (net.jmchilton.www utils)))


(deftest test-as-int
  (is (= (as-int 5) 5))
  (is (= (as-int "5") 5))
  (is (= (as-int "B" 16) 11)))
        
(deftest test-as-str
  (is (= (.toString 5) "5")))
