(ns net.jmchilton.www.xml-test
  (:use clojure.test
        clojure.xml
        net.jmchilton.www.xml))

(deftest test-children-with-tag
	(let [xml (parse-xml "<root><moo /><cow /><cow /><foo /></root>")]
	  (is (= 1 (count (get-children-with-tag xml :foo))))
	  (is (= 2 (count (get-children-with-tag xml :cow))))))

;(deftest test-xml-seq-versus-parse
;  (let [raw-parse (parse-xml "<root><child attr=\"moo\"><subchild /></child></root>")]
;    (pr raw-parse)
;    (println)
;    (pr (xml-seq raw-parse))))



