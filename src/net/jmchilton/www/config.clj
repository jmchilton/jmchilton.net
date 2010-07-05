(ns net.jmchilton.www.config)

(defn get-config [config-name]
  "Reads a clojure object from a file with specified name in ${user.home}/.jmchilton/"
  (let [path (str (System/getProperty "user.home") "/.jmchilton/" config-name)
        file (new java.io.File path)
        contents (org.apache.commons.io.FileUtils/readFileToString file)]
    (read-string contents)))
