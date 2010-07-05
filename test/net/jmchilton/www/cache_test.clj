(ns net.jmchilton.www.cache-test
  (:use 
    clojure.test
    (net.jmchilton.www cache)))

(deftest test-handle-cache
  (def count-var 0) 
  (def inc-count (fn [] (def count-var (+ count-var 1)) "moo"))
  (is (= "moo" (handle-cache (fn [time] false) "test" inc-count)))
  (is (= count-var 1))
  (is (= "moo" (handle-cache (fn [time] false) "test" inc-count)))
  (is (= count-var 1))
  (is (= "moo" (handle-cache (fn [time] false) "test" inc-count)))
  (is (= count-var 1))
  (is (= "moo" (handle-cache (fn [time] true) "test" inc-count)))
  (is (= count-var 2)))





   
