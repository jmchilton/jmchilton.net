(ns net.jmchilton.www.id)

(use '(net.jmchilton.www io))

(def default-extension ".clj")
(def path-prefix-for-relative-ids "./src/net/jmchilton/www/pages/")

(defn content-id->path [content-id]
  "Returns a file system path for the given content id."
  (let [abs? (.startsWith content-id ":")
        ;; Need to add an extension if this is a relative
        ;; id and doesn't already have one.
        need-extension? (not (and abs? (.contains content-id ".")))]
    ;; Make sure path starts with "." so that 
    ;;absolute paths cannot be specified
    (str (if abs? "." path-prefix-for-relative-ids)
         (.replaceAll content-id ":" "/")
         (if need-extension? default-extension ""))))

(defn content-id->file [content-id]
  "Returns a Java File corresponding to the speicifed content-id."
  (new java.io.File (content-id->path content-id)))

(defn file->content-id [file]
  "Returns the content-id corresponding to the specified File object."
  (let [path (.getPath file)]
    (.replaceAll (.substring path (if (.startsWith path ".") 1 0)) "/" ":")))

(defn get-content-extension [content-id]
  (get-extension (content-id->path content-id)))

;; Checks that page destination only consists of alpha numeric
;; characters and underscores and dashes so that arbitrary files
;; cannot be loaded. Make sure . only allowed for extension or cwd by
;; limiting numer . to 1, if more can do .. and mess with path etc.
(defn- valid-content-id-string? [content-id]
  (let [regexp "[A-Za-z0-9_\\-\\.:\\!]+"
        dot-pos (.indexOf content-id "\\.")
        matched (.matches content-id regexp)]
    (and
      matched
      (or (= dot-pos -1)
          (and (> dot-pos 0)
               (= (.indexOf content-id "\\." dot-pos) -1))))))

(defn valid-content-id? [content-id]
  (and (not (nil? content-id))
       (valid-content-id-string? content-id) 
       (.exists (content-id->file content-id))))

