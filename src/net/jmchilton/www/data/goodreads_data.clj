(ns net.jmchilton.www.data.goodreads-data
  (:use (net.jmchilton.www goodreads scheduling config)))

;; Configuration
(def goodreads-config (get-config "goodreads"))

(def goodreads-agent (agent []))

(periodically-send-off goodreads-agent (every 30 minutes) (fn [_] (get-reviews goodreads-config)))
