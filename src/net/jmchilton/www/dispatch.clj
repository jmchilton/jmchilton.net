(ns net.jmchilton.www.dispatch
  (:use (net.jmchilton.www page image css)))

(defn page-handler [req]
  {:status 200
   :headers { "Content-Type" "text/html"}
   :body (get-document req) })

(defn image-handler [req]
  {:status 200
   :headers { "Content-Type" "image/png"}
   :body (get-image (:uri req))})

(defn css-handler [req]
  {:status 200
   :headers {"Content-Type" "text/css"}
   :body (get-css (:uri req))})

(def handlers 
  { "/index\\.html" page-handler
    "/bg.*\\.png" image-handler
    "/jmchilton.css" css-handler })
             
(def handler 
  (fn [req] 
    (let [uri (:uri req)
          key (some (fn [pattern] (if (.matches uri pattern) pattern)) (keys handlers))]
      (if key ((get handlers key) req)
              {:status 404}))))

