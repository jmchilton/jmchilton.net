(ns net.jmchilton.www.http-test
  (:use clojure.test
        (net.jmchilton.www http)))

(deftest test-build-label-map
  (is (string? (:content (http-get "http://www.google.com")))))

