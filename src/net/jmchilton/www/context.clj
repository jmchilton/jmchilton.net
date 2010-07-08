(ns net.jmchilton.www.context)

;; Thread local constants
(def *request*)
(def *content-id*)

(defn init-context [request content-id]
  (def *request* request)
  (def *content-id* content-id))
