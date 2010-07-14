(ns net.jmchilton.www.http
  (:require [com.twinql.clojure.http :as http])
  (:use (net.jmchilton.www xml)))

(defn expand-params [arg-seq]
  (let [{:keys [username password]} (apply hash-map arg-seq)]
    (concat
      arg-seq
      (if username (list :filters (list (http/preemptive-basic-auth-filter (str username ":" password)))))
      (if (not (contains? arg-seq :as)) (list :as :string)))))
      
(defn http-get [url & args]
  (apply http/get url (expand-params args)))

(defn http-get-xml [url & args]
  (let [content-string (apply http-get (cons url args))]
    (parse-xml (:content content-string))))
