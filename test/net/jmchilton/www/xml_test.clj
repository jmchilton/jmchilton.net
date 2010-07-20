(ns net.jmchilton.www.xml-test
  (:use clojure.test
        clojure.xml
        net.jmchilton.www.xml))

(deftest test-children-with-tag
	(let [xml (parse-xml "<root><moo /><cow /><cow /><foo /></root>")]
	  (is (= 1 (count (get-children-with-tag xml :foo))))
	  (is (= 2 (count (get-children-with-tag xml :cow))))))

(deftest test-parse-rss-date
  (let [parsed-date (parse-rss-date "Sat, 03 Jul 2010 15:53:34 +0000")]
    (is (= (.get parsed-date java.util.Calendar/YEAR) 2010))
    (is (= (.get parsed-date java.util.Calendar/MINUTE) 53)))

	(let [parsed-date (parse-rss-date "Sat, 03 Jul 10 15:53:34 +0000")]
    (is (= (.get parsed-date java.util.Calendar/YEAR) 2010))
    (is (= (.get parsed-date java.util.Calendar/MINUTE) 53))))

;(deftest test-xml-seq-versus-parse
;  (let [raw-parse (parse-xml "<root><child attr=\"moo\"><subchild /></child></root>")]
;    (pr raw-parse)
;    (println)
;    (pr (xml-seq raw-parse))))



