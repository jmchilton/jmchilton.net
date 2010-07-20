(ns net.jmchilton.www.data.foursquare-data
  (:use (net.jmchilton.www scheduling foursquare)))

(def foursquare-cache (agent-cache []))

(periodically-update foursquare-cache (every 5 minutes) get-parsed-foursquare-rss)
