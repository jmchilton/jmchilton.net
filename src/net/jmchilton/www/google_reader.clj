(ns net.jmchilton.www.google-reader
  (:use (net.jmchilton.www google http)))

;; Blogroll code
(def subscription-url "http://www.google.com/reader/api/0/subscription/list")

(defn- object->map [object]
  (zipmap
    (map #(keyword (:name (:attrs %))) (:content object))
    (map #(let [val (first (:content %))] 
            (if (map? val) (object->map val) val)) 
         (:content object))))
 
(defn extract-subscription-list [raw-subscriptions]
  (let [objects (:content (first (:content raw-subscriptions)))]
    (map object->map objects)))

(defn- get-label [subscription]
  (let [categories (:categories subscription)]
    (and categories (:label categories))))

(defn build-label-map [subscriptions unlabelled-string]
  (reduce
    (fn [label-map subscription]
      (let [label (or (get-label subscription) unlabelled-string)
            singleton-map {label (list subscription)}]
        (merge-with concat singleton-map label-map)))
    {}
    subscriptions))

(defn get-raw-subscriptions [google-config]
   (http-get-xml subscription-url :headers (get-google-auth-headers google-config)))

(defn get-subscription-list [google-config]
  (extract-subscription-list (get-raw-subscriptions google-config)))


;; Shared Items code

(def shared-items-url "www.google.com/reader/public/atom/user/17304313608845144333/state/com.google/broadcast")
