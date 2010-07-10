(ns net.jmchilton.www.source-test
  (:use 
    clojure.test
    (net.jmchilton.www source)))

(defn- file [path] (new java.io.File path))

(deftest test-valid-content-id?
  (is (valid-source-content-id? "sitemap")) 
  (is (valid-source-content-id? "school:index"))
  (is (valid-source-content-id? ":test:net:jmchilton:www:source_test.clj"))
  (is (not (valid-source-content-id? "..:pages:site")))
  (is (not (valid-source-content-id? "/sitemap")))
  (is (not (valid-source-content-id? "school:menu")))
  (is (not (valid-source-content-id? ":sitemap.clj")))
  (is (not (valid-source-content-id? ":sitemap")))
  (is (not (valid-source-content-id? "sitemoo"))))
