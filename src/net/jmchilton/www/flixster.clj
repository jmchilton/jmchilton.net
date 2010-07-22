(ns net.jmchilton.www.flixster
  (:use (net.jmchilton.www http xml utils)))

(defn- get-flixster-rss []
  (http-get-xml "http://www.flixster.com/api/v1/users/jmchilton/ratings.rss"))

(defn- parse-item [rss-item-hash]
  (assoc (swap-key rss-item-hash :title :description)
         :source
         :flixster))


(defn parse-items [rss-xml]
  (map-rss-items parse-item rss-xml))

(defn get-parsed-flixster-rss []
	(parse-items (get-flixster-rss)))