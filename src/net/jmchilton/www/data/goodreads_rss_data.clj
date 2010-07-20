(ns net.jmchilton.www.data.goodreads-rss-data
  (:use (net.jmchilton.www scheduling goodreads-rss)))

(def goodreads-rss-cache (agent-cache []))

(periodically-update goodreads-rss-cache (every 5 minutes) get-parsed-goodreads-rss)
