(ns net.jmchilton.www.data.delicious-data
  (:use (net.jmchilton.www scheduling config utils delicious)))

;; Configuration

(def delicious-config (get-config "delicious"))
(def delicious-username (:username delicious-config))
(def delicious-password (:password delicious-config))

(defn- update-predicate [last-updated]
  (and (> (delicious-update-time delicious-username delicious-password) last-updated)))

(def delicious-cache (agent-cache nil)) ;(delicious-get-posts delicious-username delicious-password)))

(periodically-update delicious-cache (every 10 minutes) update-predicate (fn [] (delicious-get-posts delicious-username delicious-password)))
