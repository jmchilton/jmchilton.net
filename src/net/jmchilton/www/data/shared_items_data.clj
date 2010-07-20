(ns net.jmchilton.www.data.shared-items-data
  (:use (net.jmchilton.www scheduling google-shared-items)))

(def shared-items-cache (agent-cache []))

(periodically-update shared-items-cache (every 5 minutes) get-parsed-shared-items)
