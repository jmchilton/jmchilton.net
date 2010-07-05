(ns net.jmchilton.www.io-test
  (:use 
    clojure.test
    (net.jmchilton.www io)))


(deftest test-get-extension
  (is (= (get-extension "/moo/cow/foo") ""))
  (is (= (get-extension "foo.txt") "txt"))
  (is (= (get-extension "/moo/cow.exe") "exe")))

(deftest test-stream->string
  (is (= (stream->string (new java.io.ByteArrayInputStream (.getBytes "moo"))) "moo")))