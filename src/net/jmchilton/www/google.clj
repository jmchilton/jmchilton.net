(ns net.jmchilton.www.google
  (:require [com.twinql.clojure.http :as http])
  (:use [clojure.contrib.string :only [join as-str]]
        (net.jmchilton.www config io http xml)))

;; Google Configuration
(def google-config (get-config "google"))

;; ClientLogin Configuration
(def email (:email google-config))
(def password (:password google-config))

(def subscription-url "http://www.google.com/reader/api/0/subscription/list")
(def view-url "http://www.google.com/reader/view/")

(defn client-login-response [email password]
  (let [params {:Email email :Passwd password :service "reader" :source "jmchilton-www-0.1" :accountType "GOOGLE"}]
    (http/get "https://www.google.com/accounts/ClientLogin" 
              :query params
              :parameters (http/map->params {:use-expect-continue false})
              :as :string)))

(defn extract-auth [response-str]
  (let [start (+ 5 (.indexOf response-str "Auth="))
        end (.indexOf response-str "\n" start)]
    (.substring response-str start end)))

(defn client-login-auth [email password]
  (extract-auth
    (:content (client-login-response email password))))
  
(defn- object->map [object] 
  (let [flattened-list 
          (mapcat 
            (fn [x] 
              (let [val (first (:content x))
                    expanded-val (if (map? val) (object->map val) val)]
                (list (keyword (:name (:attrs x))) expanded-val)))
            (:content object))]
    (if (empty? flattened-list) {} (apply assoc {} flattened-list))))

(defn extract-subscription-list [raw-subscriptions]
  (map object->map (:content (first (:content raw-subscriptions)))))


(defn- get-label [subscription]
  (let [categories (:categories subscription)]
    (if (nil? categories) nil (:label categories))))

(defn build-label-map [subscriptions unlabelled-string]
  (reduce
    (fn [label-map subscription]
      (let [label (get-label subscription)
            singleton-map {(if (nil? label) unlabelled-string label) (list subscription)}]
        (merge-with concat singleton-map label-map)))
    {}
    subscriptions))
    
        

(defn get-raw-subscriptions [auth]
  (parse-xml
    (:content
      (http/get subscription-url
                :headers {"Authorization" (str "GoogleLogin auth=" auth)}
                :as :string))))

(defn get-subscription-list []
  (let [auth (client-login-auth email password)]
    (extract-subscription-list (get-raw-subscriptions auth))))
