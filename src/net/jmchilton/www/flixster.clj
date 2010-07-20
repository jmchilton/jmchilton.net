(ns net.jmchilton.www.flixster
  (:use (net.jmchilton.www http xml utils)))

(defn- get-flixster-rss []
  (http-get-xml "http://www.flixster.com/api/v1/users/jmchilton/ratings.rss"))

(defn parse-items [rss-xml]
  (map-rss-items #(assoc % :source :flixster) rss-xml))

(defn get-parsed-flixster-rss []
	(parse-items (get-flixster-rss)))