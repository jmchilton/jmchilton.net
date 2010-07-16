(ns net.jmchilton.www.google-reader-test
  (:use clojure.test
        (net.jmchilton.www google-reader)))

(def raw-subscription
  {:tag :object, :attrs nil, :content [{:tag :string, :attrs {:name "id"}, :content ["feed/http://blogs.construx.com/blogs/stevemcc/rss.aspx"]} {:tag :string, :attrs {:name "title"}, :content ["10x Software Development"]} {:tag :list, :attrs {:name "categories"}, :content [{:tag :object, :attrs nil, :content [{:tag :string, :attrs {:name "id"}, :content ["user/17304313608845144333/label/Programming"]} {:tag :string, :attrs {:name "label"}, :content ["Programming"]}]}]} {:tag :string, :attrs {:name "sortid"}, :content ["C580EF73"]} {:tag :number, :attrs {:name "firstitemmsec"}, :content ["1220992087693"]}]})

(def raw-subscriptions (load-file "resources/default_blogroll.clj"))

(deftest test-subscription-parsing
  (is (not (nil? (extract-subscription-list raw-subscriptions)))))

(deftest test-build-label-map
  (let [s1 {:categories {:label "moo"}}
        s2 {:categories {:label "moo"}}
        s3 {:categories {:label "cow"}}
        s4 {:categories {}}
        s5 {}
        subscriptions (list s1 s2 s3 s4 s5)
        label-map (build-label-map subscriptions "*unlabelled*")]
    (is (= (count (keys label-map)) 3))
    (is (= (count (get label-map "moo")) 2))
    (is (= (count (get label-map "cow")) 1))
    (is (= (count (get label-map "*unlabelled*")) 2)))) 
