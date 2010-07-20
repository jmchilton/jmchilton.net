(ns net.jmchilton.www.data.twitter-data
  (:use (net.jmchilton.www scheduling twitter)))

(def twitter-cache (agent-cache []))

(periodically-update twitter-cache (every 5 minutes) get-parsed-twitter-rss)
