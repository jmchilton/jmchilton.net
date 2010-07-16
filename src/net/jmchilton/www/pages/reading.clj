(use '(net.jmchilton.www config http cache))
(use '(net.jmchilton.www.data goodreads-data))

(defn get-review-markup [{rating :rating body :body 
                           {title :title isbn :isbn image :image link :link} :book}
                         index]
  [:div {"class" (str "review review-" (if (odd? index) "odd" "even"))}
    [:img {"src" image "alt" (str title " Book Cover")}]
    [:span {"class" "review-title"} 
      "Book: " 
      [:a {"href" link} title]]
    [:span {"class" "review-rating"} "Rating: " rating "/5"]
    [:p body]])

(defn get-reading-markup []
  (let [reviews @goodreads-agent]
    `([:p "Here is a collection of books I highly recommended books. This data is
           populate from " [:a {"href" "http://www.goodreads.com/"} "goodreads"] ". 
           You can find my goodreads profile " 
           [:a {"href" "http://www.goodreads.com/user/show/3983175"} "here"]
           ", and all of my goodreads reviews and ratings "
           [:a {"href" "http://www.goodreads.com/review/list/3983175?sort=review&view=reviews"} "here"] 
           "."] 
      [:div {"class" "reviews"} ~@(map get-review-markup reviews (range (count reviews)))])))

(get-reading-markup)

;(handle-cache-timed
;  (* 1000 60 60 4)
;  "reading"
;  get-reading-markup)
