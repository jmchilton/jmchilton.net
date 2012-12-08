(defproject www "0.0.1-SNAPSHOT"
  :description "Test WWW Project"
  :dependencies [[org.clojure/clojure "1.2.0"]
                 [org.clojure/clojure-contrib "1.2.0"]
;                 [clojure-http-client/clojure-http-client "1.1.0-SNAPSHOT"]
                 [ring/ring "0.2.5"]
                 [ehcache/ehcache "1.2.3"]
                 [commons-lang/commons-lang "2.5"]
                 [cssgen/cssgen "0.2.1"]
                 ;Taking too much memory for now, removing this
                 ;[org.clojars.bmabey/congomongo "0.1.2-SNAPSHOT"]
                 [com.twinql.clojure/clj-apache-http "2.2.0"]])
