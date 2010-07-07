(use '(net.jmchilton.www config delicious cache xml))

(defn- post->link [post]
  [:li [:a {"href" (:href post)} (escape-xml (:description post))]])

(defn- convert-tree [tree]
  (mapcat
    (fn [entry]
      (if (= (key entry) :posts)
          (map post->link (val entry))
          `([:li ~(key entry)
              [:ul ~@(convert-tree (val entry))]])))
    (seq tree)))

(defn build-page [username tags post-tree]
  `([:p "Here is a categorized tree of links created from my "
        [:a {"href" "http://del.icio.us/jmchilton"} "del.icio.us"]
        " tags."]
    [:div {"class" "flatList"}
      [:ul
        ~@(map
            (fn [entry]
              [:li [:a {"href" (str "http://del.icio.us/" username "/" (key entry))}
                   (key entry)
                   "("
                   (val entry)
                   ")"]])
            (sort tags))]]
    [:div {"class" "treeList"}
      [:ul ~@(convert-tree post-tree)]]))

(let [config (get-config "delicious")
      username (:username config)
      password (:password config)
      expired-predicate
        (fn [cache-time]
          (let [time-since-cache (- (current-time) cache-time)]
            (and (> time-since-cache (* 1000 60 5))
                 (> (delicious-update-time username password) cache-time))))]
  (handle-cache 
    expired-predicate
    "links"
    (fn []       
      (let [posts (delicious-get-posts username password)
            tags (build-tag-map posts)
            post-tree (build-post-tree posts)] 
        (build-page username tags post-tree)))))
