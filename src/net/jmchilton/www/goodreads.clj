(ns net.jmchilton.www.goodreads
  (:use (net.jmchilton.www utils)))

(defn- extract-raw-reviews-list [raw-list-response]
  (:content (second (:content raw-list-response))))

(defn- get-content-with-tag [raw-object tag]
  (some #(and (= (:tag %) tag) %) (:content raw-object)))

(defn- get-simple-content-with-tag [raw-object tag]
  (let [raw-content (get-content-with-tag raw-object tag)
        content (first (:content raw-content))]
    (and content (.trim content))))

(defn- extract-book [raw-book]
  (let [title (get-simple-content-with-tag raw-book :title)
        isbn  (get-simple-content-with-tag raw-book :isbn)
        image (get-simple-content-with-tag raw-book :image_url)
        link  (get-simple-content-with-tag raw-book :link)]
    {:title title 
     :isbn isbn
     :image image
     :link link}))

(defn- extract-review [raw-review]
  (let [rating   (get-simple-content-with-tag raw-review :rating)
        body     (get-simple-content-with-tag raw-review :body)
        raw-book (get-content-with-tag raw-review :book)
        book     (extract-book raw-book)]
    {:rating rating
     :body body
     :book book}))

(defn extract-reviews [raw-reviews-list]
  (sort-by #(* -1 (as-int (:rating %)))
    (map extract-review (extract-raw-reviews-list raw-reviews-list))))