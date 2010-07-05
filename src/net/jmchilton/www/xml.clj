(ns net.jmchilton.www.xml)

(defn parse-xml [str]
  (clojure.xml/parse (new java.io.ByteArrayInputStream (.getBytes str))))
