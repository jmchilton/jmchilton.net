(ns net.jmchilton.www.goodreads-rss
  (:use (net.jmchilton.www http xml utils)))

(defn- get-goodreads-rss []
  (http-get-xml "http://www.goodreads.com/user/updates_rss/3983175"))

(defn- parse-item [rss-item-hash]
  (assoc (swap-key rss-item-hash :title :description)
         :source
         :goodreads))

(def parse-items #(map-rss-items parse-item %))

(defn get-parsed-goodreads-rss []
	(parse-items (get-goodreads-rss)))