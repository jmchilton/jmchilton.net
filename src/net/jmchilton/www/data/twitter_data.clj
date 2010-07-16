(ns net.jmchilton.www.data.twitter-data
  (:use (net.jmchilton.www scheduling twitter)))

(def twitter-cache (agent-cache []))

(periodically-update twitter-cache (every 5 minutes) (fn [] (get-parsed-twitter-rss)))
