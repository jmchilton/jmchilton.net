(use '(net.jmchilton.www config delicious cache xml))
(use '(net.jmchilton.www.data delicious-data))

(defn- post->link [post]
  [:li [:a {"href" (:link post)} (escape-xml (:description post))]])

(defn- convert-tree [tree]
  (mapcat
    (fn [entry]
      (if (= (key entry) :posts)
          (map post->link (val entry))
          `([:li [:span {"class" "collapsable"} ~(key entry)]
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

(let [posts (:content @delicious-cache)
      tags (build-tag-map posts)
      post-tree (build-post-tree posts)] 
  (build-page delicious-username tags post-tree))
