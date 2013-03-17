(ns net.jmchilton.www.twitter
  (:use (net.jmchilton.www http xml utils)))

(defn- get-twitter-rss []
  (http-get-xml "http://api.twitter.com/1/statuses/user_timeline.rss?screen_name=jmchilton"))

(defn parse-items [rss-xml]
  (map-rss-items #(assoc % :source :twitter) rss-xml))

(defn get-parsed-twitter-rss []
	(parse-items (get-twitter-rss)))