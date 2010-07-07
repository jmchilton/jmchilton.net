(ns net.jmchilton.www.xml)

(defn parse-xml [str]
  (clojure.xml/parse (new java.io.ByteArrayInputStream (.getBytes str))))

(defn escape-xml [str]
  (org.apache.commons.lang.StringEscapeUtils/escapeXml str))