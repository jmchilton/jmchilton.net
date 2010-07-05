; Script for launching site!
(ns net.jmchilton.www.launch
  (:use (ring.adapter jetty)))

(load "/net/jmchilton/www/site")

(run-jetty #'net.jmchilton.www.site/site {:port 8080})
