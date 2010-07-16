(ns net.jmchilton.www.xml)

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