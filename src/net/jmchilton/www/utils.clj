(ns net.jmchilton.www.utils
  (:require [clojure.contrib.string :as string]))

(def as-str string/as-str)

(defn as-int 
  ([x] (as-int x 10)) 
  ([x radix]
    (Integer/parseInt (as-str x) radix)))

