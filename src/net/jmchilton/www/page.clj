; Script for launching site!
(ns net.jmchilton.www.page
  ;; Cannot be loaded from inside of pages, load it here
  (:require [com.twinql.clojure.http :as http])
  (:use (net.jmchilton.www counters id)
        (hiccup core)))

;; Thread local constants
(def *request*)
(def *page*)

(defn- xhtml-html-tag [& rest]
  (html
    [:html {:xmlns "http://www.w3.org/1999/xhtml"
            :xml:lang "en"}
      rest]))

(defn- content->title [page]
  (str "jmchilton.net / " (.replaceAll page ":" " / ")))

(defn- get-head [page]
  [:head
    [:title (content->title page)]
    [:link {"rel" "stylesheet" "href" "style.css" "type" "text/css"}]])

(defn implode [seq str]
  (.join (com.google.common.base.Joiner/on str) seq))

(defn get-menu-list [dir-content-id]
  (let [menu-content-id (if (= "" dir-content-id) "menu" (str dir-content-id ":menu"))
        menu-path (content-id->path menu-content-id)]
    (load-file menu-path)))

(defn- get-menu [dir]
  (let [menu-lst (get-menu-list dir)]
    `[:ul 
      ~@(map
          (fn [entry]
            (let [abs? (= (first entry) 'abs)
                  target (nth entry 1)
                  href (if abs? target (str "index.html?page=" target))]
              [:li [:a {"href" href} (nth entry 2)]]))
          menu-lst)]))

(defn get-modified-date-string [page]
  (let [last-modified-timestamp (.lastModified (content-id->file page))
        formatter org.apache.commons.lang.time.DateFormatUtils/ISO_DATETIME_FORMAT]
    (.format formatter last-modified-timestamp)))

(defn- get-header [page]
  (let [title-els (cons "jmchilton.net" (seq (.split page ":")))
        n (count title-els)]
    `[:div {"class" "menu"} 
      ~@(mapcat
          (fn [i]
            (let [index (min (- n 1) (+ i 1))
                  cur-path-pieces (rest (take index title-els))
                  cur-path (implode cur-path-pieces "/")]
              (concat
                (if (< i (- n 1))
                  (list [:div (str "john@jmchilton.net (~/" cur-path ") % ls")]
                        [:div (get-menu cur-path)])
                  (list))
                (if (< i (- n 2))
                  (list [:div (str "john@jmchilton.net (~/" cur-path ") % cd " (nth title-els (+ 1 i)))])
                  (list))
                (if (= i (- n 1 ))
                  (list [:div (str "john@jmchilton.net (~/" cur-path ") % cat " (nth title-els i))])
                  (list)))))
          (range n))]))

(defn- get-content [page]
  (load-file (content-id->path page)))

(defn view-source-link  [page text]
  [:a {"href" (str "index.html?page=code_display&source=" page)} text])

(def validate-p 
  [:p "validate: " 
      [:a {"href" "http://jigsaw.w3.org/css-validator/check/referer"} "CSS"]
      " "
      [:a {"href" "http://validator.w3.org/check/referer"} "XHTML"]])

(def powered-p
  [:p "powered by: "
      [:a {"href" "http://clojure.org/"} "Clojure"]
      " | "
      [:a {"href" "http://github.com/mmcgrana/ring"} "Ring"]
      " | "
      [:a {"href" "http://jetty.codehaus.org/jetty/"} "Jetty"]
      " | "
      [:a {"href" "http://www.mongodb.org/"} "MongoDB"]]) 

(defn- get-body [page]
  (if (valid-content-id? page)
    [:body 
      [:div {"id" "page"}
        (get-header page)
        (let [content (get-content page)]
          `[:div {"id" "content"} ~(if (list? content) content (list content))])]
      [:div {"id" "infoBox"} 
        [:p "clojure page source: " 
            (view-source-link page (.substring (content-id->path page) 2)) ]
        validate-p
        [:p "created by: John Chilton (jmchilton at gmail dot com)"]
        [:p "page loaded: " (inc-counter! (content-id->path page)) " times"]
        [:p "date last modified: " (get-modified-date-string page)]
        powered-p]]
    [:body [:p "Server Error"]]))

(defn- get-html [req]
  (let [params (:params req)
        page   (:page params)]
    (def *request* req)
    (def *page* page)
    (xhtml-html-tag 
      (get-head page) 
      (get-body page))))

(defn get-document [req]
  (str
    "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>"
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n"
    (get-html req)))
