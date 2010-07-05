(ns net.jmchilton.www.http
  (:use (clojure-http client)
        (net.jmchilton.www xml)))

(defn authorize-url [url username password]
  (if (nil? username) url (.replace url "://" (str "://" username ":" password "@"))))

(defn wget-auth-xml [url username password]
  (let [url-with-auth (authorize-url url username password)
        content-sequence (:body-seq (request url-with-auth))
        content-string (apply str content-sequence)]
    (parse-xml content-string)))

(defn map->query [input-map]
  (let [entries (map (fn [entry] (str (key entry) "=" (val entry))) (seq input-map))]
    (if (empty? entries) "" (reduce (fn [el rest] (str el "&" rest)) entries))))
