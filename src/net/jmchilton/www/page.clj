; Script for launching site!
(ns net.jmchilton.www.page
  (:use (com.twinql.clojure.http)
        (net.jmchilton.www id context source)
        (hiccup core)))

;; Contrib seems unstable in some way, many random erros when using
(defn #^String join
  "Returns a string of all elements in coll, separated by
  separator.  Like Perl's join."
  [#^String separator coll]
  (apply str (interpose separator coll)))



(def jquery-href "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js")

(defn- xhtml-html-tag [& rest]
  (html
    [:html {:xmlns "http://www.w3.org/1999/xhtml"
            :xml:lang "en"}
      rest]))

(defn- content->title [page]
  (str "jmchilton.net / " (.replaceAll page ":" " / ")))

(defn- script [href]
  [:script {"type" "text/javascript" "src" href}])

(defn- get-head [page]
  [:head
    [:title (content->title page)]
    [:link {"rel" "stylesheet"
            "href" "http://fonts.googleapis.com/css?family=Inconsolata|Droid+Sans+Mono"
            "type" "text/css"}]
    [:link {"rel" "stylesheet" "href" "jmchilton.css" "type" "text/css"}]
    (script jquery-href)
    (script "js/jquery.corner.js")
    (script "js/jmchilton.js")
    [:script {"type" "text/javascript"}
      "var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-17389648-1']);
_gaq.push(['_trackPageview']);
(function() {
   var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
   ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
   var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
 })();"]])


(defn get-menu-list [dir-content-id]
  (let [menu-content-id (if (= "" dir-content-id) "menu" (str dir-content-id ":menu"))
        menu-path (content-id->path menu-content-id)]
    (load-file menu-path)))

(defn- get-menu [dir]
  (let [menu-lst (get-menu-list dir)]
    `[:ul {"class" "initially-undisplayed"}
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
                  cur-path (join "/" cur-path-pieces)]
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
      [:a {"href" "http://jetty.codehaus.org/jetty/"} "Jetty"]]) 

(defn- get-body [page]
  [:body 
    [:div {"id" "page-border"}
    [:div {"id" "page"}
      (get-header page)
      (let [content (get-content page)]
        `[:div {"id" "content"} ~(if (list? content) content (list content))])]]
    [:div {"id" "infoBox-container"}
    [:div {"id" "infoBox-border"}
    [:div {"id" "infoBox"} 
      [:p "clojure page source: " 
          (view-source-link page (.substring (content-id->path page) 2)) ]
      validate-p
      [:p "created by: John Chilton (jmchilton at gmail dot com)"]
      ;; Disabling mongo counter for now
      ;; [:p "page loaded: " (inc-counter! (content-id->path page)) " times"]
      [:p "date last modified: " (get-modified-date-string page)]
      powered-p]]]])


(defn- get-content-id [params]
  (let [page-param (:page params)]
    (cond (valid-content-id? page-param) page-param 
          (nil? page-param) "index"
          :else "error")))

(defn- get-html [req]
  (let [params (:params req)
        content-id (get-content-id params)]
    (init-context req content-id)
    (xhtml-html-tag 
      (get-head content-id) 
      (get-body content-id))))

(defn get-document [req]
  (str
    "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>"
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n"
    (get-html req)))
