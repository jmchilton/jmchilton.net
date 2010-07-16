(use '(net.jmchilton.www.data twitter-data delicious-data))

(defn- update-type-str [source]
	(cond (= source :delicious) "delicious bookmark"
	      (= source :twitter) "tweet"))

(def update-date-formatter (java.text.SimpleDateFormat. "EEE, dd-MMM-yyyy HH:mm"))

(defn- format-date [calendar]
	(.format update-date-formatter (.getTime calendar)))

(defn- format-item [{link :link source :source date :date description :description}]
  [:span {"class" "update"}
	  [:a {"href" link} (update-type-str source)]
	  [:p description]
	  [:span {"class" "update-date"} (format-date date) ]
])

(defn- get-data []
	(take 30 (reverse (sort-by :date (concat (:content @twitter-cache) (:content @delicious-cache))))))

`( [:div {"id" "updates"} [:p "sed -n '1!G;h;$p' /dev/life | more"] ~@(map format-item (get-data))]
	 [:p "My name is John Chilton and I am a software developer at the Minnesota "
    "Supercompuing Institute at the University of Minnesota. I hope you find something "
    "interesting."]
 )