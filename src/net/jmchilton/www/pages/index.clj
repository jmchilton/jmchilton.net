(use 'net.jmchilton.www.display-utils)
(use '(net.jmchilton.www.data twitter-data 
                              shared-items-data
                              blog-data
                              foursquare-data
                              goodreads-rss-data
                              flixster-data
                              delicious-data))

(defn- update-type-str [source]
	(cond ;(= source :delicious) "delicious bookmark"
	      (= source :twitter) "tweet"
        ;(= source :google-shared-items) "google shared item"
        ;(= source :blog) "jmchilton.net / blog"
        ;(= source :goodreads) "goodreads update"
        ;(= source :foursquare) "foursquare checkin"
        ;(= source :flixster) "flixster review"
        ;(= source :facebook) "facebook update"))
        ))

(defn- format-item [{link :link source :source date :date description :description}]
  [:span {"class" "update"}
	  [:a {"href" link} (update-type-str source)]
	  [:p description]
	  [:span {"class" "update-date"} (format-date date)]])

(defn- get-data []
  (let [caches (list @twitter-cache
                     ;@delicious-cache
                     ;@facebook-cache
                     ;@blog-cache
                     ;@goodreads-rss-cache
                     ;@foursquare-cache
                     ;@flixster-cache
                     ;@shared-items-cache)
                     )
        data (apply concat (map :content caches))
        sorted-data (reverse (sort-by :date data))]
    (take 30 sorted-data)))

`( [:div {"id" "updates"} [:p "sed -n '1!G;h;$p' /dev/life | more"] ~@(map format-item (get-data))]
	 [:p "My name is John Chilton and I am a software developer at the Minnesota 
        Supercompuing Institute at the University of Minnesota. Welcome to my website, I hope you find something 
        interesting."]

 )