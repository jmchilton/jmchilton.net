;(ns net.jmchilton.www.data.google-reader-data
;  (:use (net.jmchilton.www google-reader scheduling config)))

;; Google Configuration
;(def google-config (get-config "google"))

;(def google-reader-agent (agent (load-file "resources/default_blogroll.clj")))

;(periodically-send-off google-reader-agent (every 12 hours) (fn [_] (get-subscription-list google-config)))