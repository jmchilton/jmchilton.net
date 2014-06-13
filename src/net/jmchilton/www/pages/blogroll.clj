;(use '(net.jmchilton.www cache google-reader))
;(use '(net.jmchilton.www.data google-reader-data))

;(def view-url "http://www.google.com/reader/view/")

;(defn build-subscription-html [subscription]
;  (let [href (str view-url (:id subscription))
;        title (:title subscription)]
;    [:li [:a {"href" href} title]]))

;(defn build-label-list-html [label-map-entry]
;  [:li [:span {"class" "collapsable"} (first label-map-entry)]
;    `[:ul ~@(map build-subscription-html (second label-map-entry))]])

;(defn build-page-html []
;  (let [subscription-list (extract-subscription-list @google-reader-agent)
;        label-map (build-label-map subscription-list "*unlabelled*")]
;    `[:div {"class" "treeList"}
;       [:ul ~@(map build-label-list-html (sort label-map))]]))

;(build-page-html)