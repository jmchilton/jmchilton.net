(ns net.jmchilton.www.delicious
  (:use (net.jmchilton.www http utils)))

(def delicious-url-tags   "https://api.del.icio.us/v1/tags/")
(def delicious-url-posts  "https://api.del.icio.us/v1/posts/")
(def delicious-url-bundles "https://api.del.icio.us/v1/tags/bundles/")

(defn delicious-make-url-command [url command]
  (str url command))

(defn delicious-execute-url-command [username password url command opts]
  (http-get-xml (delicious-make-url-command url command) 
                :query opts 
                :username username 
                :password password))

(def pattern "yyyy-MM-dd'T'HH:mm:ssZZ")

(defn- parse-date [date-str]
  (let [iso-date-str (.replace date-str "Z" "+00:00")]
		(parse-date-str iso-date-str pattern)))

(defn- parse-post [post-xml]
	(let [attrs (:attrs post-xml)
	      description (:description attrs)
			  href (:href attrs)
        tag (:tag attrs)
			  date (parse-date (:time attrs))]
	  {:description description :link href :date date :source :delicious :tag tag}))

(defn delicious-get-posts [username password]
  (let [result (delicious-execute-url-command
                    username
                    password
                    delicious-url-posts
                    "all"
                    {})]
    (map parse-post (:content result))))

(defn delicious-update-time [username password]
  (let [result (delicious-execute-url-command
                 username
                 password
                 delicious-url-posts
                 "update"
                 {})]
    (.getTimeInMillis (parse-date (:time (:attrs result))))))

(defn get-tags [post]
  (let [tag (:tag post)]
    (if (nil? tag)
        '("untagged")
        (seq (.split (:tag post) " ")))))

(defn- get-tag-parts [tag]
  (seq (.split tag ":")))

(defn- post->tag-map [post]
  (map (fn [tag] {tag 1}) (get-tags post)))

(defn- append-post-with-tag [post tree tag-parts]
  (if
    (empty? tag-parts)
    (merge-with concat {:posts (list post)} tree)
    (let [first-tag-part (first tag-parts)
          subtree (append-post-with-tag post (get tree first-tag-part {}) (rest tag-parts))]
      (assoc tree first-tag-part subtree))))

(defn- append-post [tree post]
  (reduce
    (fn [accum-tree tag]
      (append-post-with-tag post accum-tree (get-tag-parts tag)))
    tree
    (get-tags post)))

(defn build-post-tree [posts]
  (reduce append-post {} posts))

(defn build-tag-map [posts]
  (let [tag-maps (mapcat post->tag-map posts)]
    (reduce #(merge-with + %1 %2) {} tag-maps)))
