(ns net.jmchilton.www.scheduling-test
  (:use clojure.test
        (net.jmchilton.www scheduling utils))) 

(deftest test-periodically-update
  (let [count (agent-cache 0)]
    (is (= (:content @count) 0))
    (periodically-update count 1 (constant 5))
    (Thread/sleep 25)
    (is (= (:content @count) 5))))

(deftest test-periodically-update-predicated
  (let [count (agent-cache 0)]
    (is (= (:content @count) 0))
    (periodically-update count 1 (constant false) (constant 5))
    (Thread/sleep 25)
    (is (not (= (:content @count) 5)))))

(deftest test-periodically-send-off
  (let [count (agent 0)]
    (is (= @count 0))
    (periodically-send-off count 1 inc)
    (Thread/sleep 25)
    (let [count-sampled @count]
      (is (> count-sampled 0))
      (Thread/sleep 25)
      (is (> @count count-sampled)))))



   
