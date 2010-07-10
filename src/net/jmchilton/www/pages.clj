
(use 'net.jmchilton.www.config)

(def goodreads-config (get-config "goodreads"))
(def api-key (:api-key goodreads-config))

(def shelf "highly-recommended")
(def id "3983175")

(defn get-list-url [shelf id]
  (str "http://www.goodreads.com/review/list?format=xml&v=2&key=" api-key "&shelf=" shelf "&id=" id))

