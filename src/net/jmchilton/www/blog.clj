(ns net.jmchilton.www.blog
  (:use (net.jmchilton.www http xml utils)))

(defn parse-items [rss-xml]
  (map-rss-items #(assoc % :source :blog) rss-xml))

(defn get-parsed-blog []
  (let [rss-xml (http-get-xml "http://jmchilton.net/blog/feed/")]
  	(parse-items rss-xml)))