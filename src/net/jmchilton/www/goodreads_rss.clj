(ns net.jmchilton.www.goodreads-rss
  (:use (net.jmchilton.www http xml utils)))

(defn- get-goodreads-rss []
  (http-get-xml "http://www.goodreads.com/user/updates_rss/3983175"))

(defn- parse-item [rss-item-hash]
  (let [title (:title rss-item-hash)]
    (assoc 
      (assoc rss-item-hash :source :goodreads)
      ;; RSS Description field a bit lengthy
      :description title)))

(def parse-items #(map-rss-items parse-item %))

(defn get-parsed-goodreads-rss []
	(parse-items (get-goodreads-rss)))