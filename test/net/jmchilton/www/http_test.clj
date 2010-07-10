(ns net.jmchilton.www.google-test
  (:use 
    clojure.test
    (net.jmchilton.www http)))

(deftest test-build-label-map
  (is (string? (http-get "http://www.google.com"))))

