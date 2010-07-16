(ns net.jmchilton.www.twitter
  (:use (net.jmchilton.www http xml utils)))

(defn- get-twitter-rss []
  (http-get-xml "http://twitter.com/statuses/user_timeline/6434632.rss"))

(defn- get-items [rss-xml]
	(get-children-with-tag (get-child-with-tag rss-xml :channel) :item))

(defn parse-twitter-date [date-str]
  (let [date-format "EEE, dd MMM yyyy HH:mm:ss Z"]
		(parse-date-str date-str date-format)))

(defn- parse-item [item-xml]
  (let [description (get-child-text-with-tag item-xml :description)
				date (parse-twitter-date (get-child-text-with-tag item-xml :pubDate))
				link (get-child-text-with-tag item-xml :link)]
	  {:description description :date date :link link :source :twitter}))

(defn parse-items [rss-xml]
	(let [items-xml (get-items rss-xml)]
    (map parse-item items-xml)))

(defn get-parsed-twitter-rss []
	(parse-items (get-twitter-rss)))