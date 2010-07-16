(ns net.jmchilton.www.twitter-test
  (:use clojure.test
        clojure.xml
        (net.jmchilton.www twitter xml)))


(deftest test-rss-parsing
  (let [xml (parse-xml (slurp "resources/twitter.rss"))]
		(pr (parse-items xml))))

(deftest test-parse-twitter-date
	(let [parsed-date (parse-twitter-date "Sat, 03 Jul 2010 15:53:34 +0000")]
	  (is (= (.get parsed-date java.util.Calendar/YEAR) 2010))
	  (is (= (.get parsed-date java.util.Calendar/MINUTE) 53))))


