(defproject www "0.0.1-SNAPSHOT"
  :description "jmchilton.net"
  :dependencies [[org.clojure/clojure "1.4.0"]
                 ;[org.clojure/clojure-contrib "1.3.0"]
                 [ring/ring "1.1.6"]
                 [ehcache/ehcache "1.2.3"]
                 [commons-lang/commons-lang "2.5"]
                 [cssgen/cssgen "0.2.6"]
                 [hiccup "1.0.2"]
                 ;Taking too much memory for now, removing this
                 ;[org.clojars.bmabey/congomongo "0.1.2-SNAPSHOT"]
                 [clj-apache-http/clj-apache-http "2.3.2"]]
  :plugins [[lein-ring "0.8.3"]]
  :ring {:handler net.jmchilton.www.site/site}
)
