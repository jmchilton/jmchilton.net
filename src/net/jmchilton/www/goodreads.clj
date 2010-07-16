(ns net.jmchilton.www.goodreads
  (:use (net.jmchilton.www utils http xml)))

(def shelf "highly-recommended")
(def id "3983175")

(def list-url "http://www.goodreads.com/review/list")

(defn- extract-raw-reviews-list [raw-list-response]
  (get-child-content-with-tag raw-list-response :reviews))

(defn- extract-book [raw-book]
  (let [title (get-trimmed-child-text-with-tag raw-book :title)
        isbn  (get-trimmed-child-text-with-tag raw-book :isbn)
        image (get-trimmed-child-text-with-tag raw-book :image_url)
        link  (get-trimmed-child-text-with-tag raw-book :link)]
    {:title title 
     :isbn isbn
     :image image
     :link link}))

(defn- extract-review [raw-review]
  (let [rating   (get-trimmed-child-text-with-tag raw-review :rating)
        body     (get-trimmed-child-text-with-tag raw-review :body)
        raw-book (get-child-with-tag raw-review :book)
        book     (extract-book raw-book)]
    {:rating rating
     :body body
     :book book}))

(defn extract-reviews [raw-reviews-list]
  (sort-by #(* -1 (as-int (:rating %)))
    (map extract-review (extract-raw-reviews-list raw-reviews-list))))

(defn get-reviews [goodreads-config]
  (let [params {"format" "xml"
                "v" "2"
                "key" (:api-key goodreads-config)
                "shelf" shelf
                "id" id}
      xml (http-get-xml list-url :query params)]
    (extract-reviews xml)))
