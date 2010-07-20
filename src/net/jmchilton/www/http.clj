
(ns net.jmchilton.www.http
  (:require [com.twinql.clojure.http :as http])
  (:use (net.jmchilton.www xml io utils)))

(defn expand-params [arg-seq]
  (let [{:keys [username password]} (apply hash-map arg-seq)]
    (concat
      arg-seq
      (if username (list :filters (list (http/preemptive-basic-auth-filter (str username ":" password)))))
      (if (not (list-contains? arg-seq :as)) (list :as :string)))))
      
(defn http-get [url & args]
  (apply http/get url (expand-params args)))

(defn http-get-xml [url & args]
  (println "Getting xml " url)
  (let [content-string (apply http-get `[~url  ~@args])
        content (:content content-string)]
;        content-str (stream->string content)
    (parse-xml content)))
