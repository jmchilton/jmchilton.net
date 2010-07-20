(ns net.jmchilton.www.facebook
  (:use (net.jmchilton.www http xml utils)))

(defn parse-items [rss-xml]
  (map-rss-items #(assoc % :source :facebook) rss-xml))

(defn get-parsed-facebook-rss [url]
  (let [rss-xml (http-get-xml url)]
  	(parse-items rss-xml)))