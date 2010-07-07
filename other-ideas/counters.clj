(ns net.jmchilton.www.counters
  (:use (somnium congomongo)))

(def *counter-map* (ref {}))

;; If this is used other places at some point move to page.clj
(mongo! :db "jmchilton")

(defn add-counter! [name]
  (dosync 
    (alter *counter-map*
      (fn [counter-map]
        (if (nil? (get counter-map name))
            (let [loaded-count (:count (fetch-one name))]
              (assoc counter-map name (agent (if (nil? loaded-count) 1 loaded-count))))
            counter-map)))))

(defn update-counter! [name]
  (fn [count]
    (let [incremented-count (inc count)]
      (update! name {:count count} {:count incremented-count})
      incremented-count)))

(defn inc-counter! [name]
  (add-counter! name)
  (let [counter (get @*counter-map* name)]
    (dosync
      (send counter (update-counter! name))
      @counter)))

