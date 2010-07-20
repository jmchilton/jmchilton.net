(ns net.jmchilton.www.foursquare
  (:use (net.jmchilton.www http xml utils)))

(defn- get-foursquare-rss []
  (http-get-xml "http://feeds.foursquare.com/history/2U4BU3PTKESBHINFTBV5HRL1FBPVFKC4.rss"))

(defn parse-items [rss-xml]
  (map-rss-items #(assoc % :source :foursquare) rss-xml))

(defn get-parsed-foursquare-rss []
	(parse-items (get-foursquare-rss)))