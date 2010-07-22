; Script for launching site!
(ns net.jmchilton.www.page
  (:use (com.twinql.clojure.http)
        (net.jmchilton.www id context source display-utils utils)
        (hiccup core page-helpers)))

(def jquery-href "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js")

(defn- content->title [page]
  (str "jmchilton.net / " (.replaceAll page ":" " / ")))

(defn- script [href]
  [:script {"type" "text/javascript" "src" href}])

(defn- css [href]
  [:link {"rel" "stylesheet" "href" href "type" "text/css"}])

(defn- get-head [page]
  [:head
    [:title (content->title page)]
    (css "http://fonts.googleapis.com/css?family=Inconsolata|Droid+Sans+Mono")
    (css "jmchilton.css")
    (script jquery-href)
    (script "js/jquery.corner.js")
;	  (script "js/jquery.jticker.js")
    (script "js/jmchilton.js")
;    (css "js/fancybox/jquery.fancybox-1.3.1.css")
;    (script "js/fancybox/jquery.fancybox-1.3.1.pack.js")
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
    `[:ul
      ~@(map
          (fn [entry]
            (let [abs? (= (first entry) 'abs)
                  target (nth entry 1)
                  href (if abs? target (str "index.html?page=" target))]
              [:li (link-to href (nth entry 2))]))
          menu-lst)]))

(defn get-modified-date-string [page]
  (let [last-modified-timestamp (.lastModified (content-id->file page))]
    (format-date last-modified-timestamp)))

(defn- get-header [page]
  (let [title-els (seq (.split page ":"))
        n (count title-els)]
    `[:div {"class" "menu"}
      ~@(mapcat
          (fn [i]
            (let [cur-path (join "/" (take i title-els))
                  cur-prefix (str "john@jmchilton.net (~/" cur-path ") % ")     
                  cmd (if (< i (- n 1)) "cd " "cat ")]
              [[:span cur-prefix "ls"]
               [:span (get-menu cur-path)]
               [:span cur-prefix cmd (nth title-els i)]]))
          (range n))]))

(defn- get-content [page]
  (load-file (content-id->path page)))

(def validate-p 
  [:p "validate: " 
      (link-to "http://jigsaw.w3.org/css-validator/check/referer" "CSS")
      " "
      (link-to "http://validator.w3.org/check/referer" "XHTML")])

(def powered-p
  [:p "powered by: "
      (link-to "http://clojure.org/" "Clojure")
      " | "
      (link-to "http://github.com/mmcgrana/ring" "Ring")
      " | "
      (link-to "http://jetty.codehaus.org/jetty/" "Jetty")])

(defn- get-url [page] (url-encode (str "http://jmchilton.net/index.html?page=" page)))
(defn- get-title [page] (url-encode (content->title page)))

(defn- get-body [page]
  [:body 
    [:div {"id" "page-border"}
    [:div {"id" "page"}
      (get-header page)
      (let [content (get-content page)]
        `[:div {"id" "content"} ~(if (list? content) content (list content))])]]
    [:div {"id" "infoBox"}
    [:div {"class" "border"}
    [:div {"class" "content"} 
      [:p "clojure page source: " 
          (view-source-link page (.substring (content-id->path page) 2)) ]
      validate-p
      [:p "created by: John Chilton (jmchilton at gmail dot com)"]
      ;; Disabling mongo counter for now
      ;; [:p "page loaded: " (inc-counter! (content-id->path page)) " times"]
      [:p "date last modified: " (get-modified-date-string page)]
      powered-p]]]
    [:div {"id" "shareBox"}
      [:div {"class" "border"}      
        [:div {"class" "content"}
          [:div {"class" "line"}
          (link-to (str "http://delicious.com/save?url=" (get-url page)
                         "&title=" (get-title page))
            [:img {"src" "http://delicious.com/favicon.ico"
                   "alt" "submit to delicious"
                   "width" "21"
                   "height" "21"
                   "border" "1"}])
          (link-to (str "http://digg.com/submit?url=" (get-url page)
                        "&title=" (get-title page))
            [:img {"src" "http://digg.com/favicon.ico"
                   "alt" "submit to digg"
                   "width" "22"
                   "height" "22"
                   "border" "0"}])
          (link-to (str "http://www.tumblr.com/share?v=3&u=" (get-url page)
                        "&t=" (get-title page))
            [:img {"src" "http://www.tumblr.com/favicon.ico"
                   "alt" "submit to tumblr"
                   "width" "22"
                   "height" "22"
                   "border" "0"}])
          (link-to (str "http://reddit.com/submit?url=" (get-url page) 
                        "&title=" (get-title page))
            [:img {"src" "http://reddit.com/static/spreddit1.gif" 
                   "alt" "submit to reddit" 
                   "width" "22"
                   "height" "22"
                   "border" "0"}])
          (link-to (str "http://twitter.com/home?status=" (get-url page))
            [:img {"src" "http://twitter-badges.s3.amazonaws.com/t_small-a.png" 
                   "border" "0"
                   "width" "22"
                   "height" "22"
                   "alt" "submit to twitter"}])           
          [:iframe {"src" (str "http://www.facebook.com/plugins/like.php?href=" (url-encode (str "http://jmchilton.net/index.html=" page)) "&layout=button_count&show_faces=true&width=90&action=like&colorscheme=light&height=20")
                   "scrolling" "no" 
                   "frameborder" "0" 
                   "allowTransparency" "true" 
                   "style" "overflow:hidden; width:90px; height:20px;"}
            (link-to (str "http://www.facebook.com/sharer.php?u=" (get-url page)) "Share on Facebook")]]]]]])

(defn- get-content-id [params]
  (let [page-param (:page params)]
    (cond (valid-content-id? page-param) page-param 
          (nil? page-param) "index"
          :else "error")))

(defn- get-html [req]
  (let [params (:params req)
        content-id (get-content-id params)]
    (init-context req content-id)
    (html 
      (xhtml-tag 
        "en" 
        (get-head content-id) 
        (get-body content-id)))))

(defn get-document [req]
  (str
    "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>"
    (doctype :xhtml-strict) "\n"
    (get-html req)))
