(ns net.jmchilton.www.delicious-test
  (:use 
    clojure.test
    (net.jmchilton.www delicious)))

(defn- list-contains? [lst el]
  (some #(= %1 el) lst))

(deftest test-get-tags
  (let [tags (get-tags {:tag "moo foo:bar"})]
    (is (list-contains? tags "moo"))
    (is (list-contains? tags "foo:bar"))))

(deftest test-build-post-tree
  (is (contains? (build-post-tree (list {:tag "moo foo:bar"})) "moo"))
  (is (contains? (build-post-tree (list {})) "untagged")))


   
