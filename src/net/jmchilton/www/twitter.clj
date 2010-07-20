(ns net.jmchilton.www.twitter
  (:use (net.jmchilton.www http xml utils)))

(defn- get-twitter-rss []
  (http-get-xml "http://twitter.com/statuses/user_timeline/6434632.rss"))

(defn parse-items [rss-xml]
  (map-rss-items #(assoc % :source :twitter) rss-xml))

(defn get-parsed-twitter-rss []
	(parse-items (get-twitter-rss)))