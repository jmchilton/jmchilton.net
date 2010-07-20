(ns net.jmchilton.www.data.flixster-data
  (:use (net.jmchilton.www scheduling flixster)))

(def flixster-cache (agent-cache []))

(periodically-update flixster-cache (every 5 minutes) get-parsed-flixster-rss)
