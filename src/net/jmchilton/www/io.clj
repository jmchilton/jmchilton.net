(ns net.jmchilton.www.io)

(defn get-extension [path]
  (org.apache.commons.io.FilenameUtils/getExtension path))

(defn file [path] 
  (new java.io.File path))

(defn stream->string [stream] 
  (org.apache.commons.io.IOUtils/toString stream))

(defn file->string [file]
  (org.apache.commons.io.FileUtils/readFileToString file))