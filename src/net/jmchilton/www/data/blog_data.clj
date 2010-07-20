(ns net.jmchilton.www.data.blog-data
  (:use (net.jmchilton.www scheduling blog)))

(def blog-cache (agent-cache []))

(periodically-update blog-cache (every 5 minutes) get-parsed-blog)
