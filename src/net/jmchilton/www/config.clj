(ns net.jmchilton.www.config
  (:use (net.jmchilton.www io)))

(defn get-config [config-name]
  "Reads a clojure object from a file with specified name in ${user.home}/.jmchilton/"
  (let [path (str (System/getProperty "user.home") "/.jmchilton/" config-name)
        file (new java.io.File path)]
    (if (.exists file) (read-string (file->string file)) nil)))

