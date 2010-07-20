(ns net.jmchilton.www.google-shared-items
  (:use (net.jmchilton.www http xml utils)))

(defn- get-shared-items-atom []
  (http-get-xml "http://www.google.com/reader/public/atom/user/17304313608845144333/state/com.google/broadcast"))

(defn- parse-entry [entry-xml]
  (let [description (get-child-text-with-tag entry-xml :title)
				date (parse-xml-date (get-child-text-with-tag entry-xml :published))        
				link (:href (:attrs (get-child-with-tag entry-xml :link)))]
	  {:description description :date date :link link :source :google-shared-items}))

(defn parse-entries [atom-xml]
	(let [entries-xml (get-children-with-tag atom-xml :entry)]
    (map parse-entry entries-xml)))

(defn get-parsed-shared-items []
	(parse-entries (get-shared-items-atom)))
