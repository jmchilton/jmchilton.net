(ns net.jmchilton.www.id-test
  (:use 
    clojure.test
    (net.jmchilton.www id)))

(defn- file [path] (new java.io.File path))

(deftest test-file->content-id
  (is (= (file->content-id (file "./moo/cow.txt")) ":moo:cow.txt"))
  (is (= (file->content-id (file "/moo/cow.txt")) ":moo:cow.txt")))

(deftest test-valid-content-id?
  (is (valid-content-id? "sitemap")) 
  (is (valid-content-id? "school:index"))
  (is (not (valid-content-id? ".:sitemap")))
  (is (not (valid-content-id? "..:pages:site")))
  (is (not (valid-content-id? "/sitemap")))
  (is (not (valid-content-id? "school:menu")))
  (is (not (valid-content-id? ":sitemap.clj")))
  (is (not (valid-content-id? ":sitemap")))
  (is (not (valid-content-id? "sitemoo"))))
