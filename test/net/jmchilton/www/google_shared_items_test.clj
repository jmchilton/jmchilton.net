(ns net.jmchilton.www.google-shared-items-test
  (:use clojure.test
        clojure.xml
        (net.jmchilton.www google-shared-items xml)))

(defn valid-item? [item]
  (and (contains? item :description)
       (contains? item :date)
       (contains? item :link)
       (= (:source item) :google-shared-items)))

(deftest test-atom-parsing
  (let [atom-xml (parse-xml (slurp "resources/google_shared_items_atom.xml"))
        items (parse-entries atom-xml)]
    (every? valid-item? items)))

