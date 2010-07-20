(ns net.jmchilton.www.data.facebook-data
  (:use (net.jmchilton.www scheduling facebook config)))

(def facebook-config (get-config "facebook"))

(def facebook-cache (agent-cache []))

(periodically-update facebook-cache 
                     (every 5 minutes) 
                     #(get-parsed-facebook-rss (:rss-url facebook-config)))
