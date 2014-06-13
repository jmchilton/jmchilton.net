(ns net.jmchilton.www.xml
  (:use net.jmchilton.www.utils)
  (:use clojure.xml))

(defn parse-xml [str]
  (clojure.xml/parse (new java.io.ByteArrayInputStream (.getBytes str))))

(defn get-children-with-tag [xml tag]
	(filter #(= tag (:tag %)) (:content xml)))

(defn get-child-with-tag [xml tag]
	(first (get-children-with-tag xml tag)))

(defn get-child-content-with-tag [xml tag]
	(:content (get-child-with-tag xml tag)))

(defn get-child-text-with-tag [xml tag]
	(first (get-child-content-with-tag xml tag)))

(defn get-trimmed-child-text-with-tag [xml tag]
	(let [text (get-child-text-with-tag xml tag)]
	  (and text (.trim text))))

(defn escape-xml [str]
  (org.apache.commons.lang.StringEscapeUtils/escapeXml str))

(defn parse-xml-date [date-str]
  (let [pattern      "yyyy-MM-dd'T'HH:mm:ssZZ"
        iso-date-str (.replace date-str "Z" "+00:00")]
    (parse-date-str iso-date-str pattern)))

(defn parse-rss-date [date-str]
  (parse-date-str
    date-str
    "EEE, dd MMM yy HH:mm:ss Z"
		"EEE, dd MMM yyyy HH:mm:ss Z"))

(defn- rss-item->hash [item-xml]
  (let [keys [:pubDate :link :description :title]
        values (map #(get-child-text-with-tag item-xml %) keys)
        pubDate (first values)]
    (assoc (zipmap keys values) :date (parse-rss-date pubDate))))

(defn get-rss-items [rss-xml]
  (let [channel-xml (get-child-with-tag rss-xml :channel)
        rss-items-xml (get-children-with-tag channel-xml :item)]
    (map rss-item->hash rss-items-xml)))

(defn map-rss-items [function rss-xml]
  (map function (get-rss-items rss-xml)))
