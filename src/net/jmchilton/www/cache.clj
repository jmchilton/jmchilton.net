(ns net.jmchilton.www.cache)

(def cache-manager (new net.sf.ehcache.CacheManager "ehcache.xml"))

(defn get-cache []
  (let [cache (.getCache cache-manager "www")]
    (if (nil? cache)
        (do
          (.addCache cache-manager "www")
          (.getCache cache-manager "www"))
        cache)))
    
(defn- element [key data] (new net.sf.ehcache.Element key data))

(defn- last-modified [element] (.getLastUpdateTime element))

(defn current-time [] (.getTime (new java.util.Date)))

(defn- put [key data]
  (.put (get-cache) (element key data))
  data)

(defn handle-cache [expired-predicate? key data-thunk] 
  (let [cached-element (.get (get-cache) key)
        cached-data (if (nil? cached-element) nil (.getValue cached-element))]
    (if (or (nil? cached-data) (expired-predicate? (last-modified cached-element)))
      (let [data  (data-thunk)]
        (put key data))
        cached-data)))

(defn handle-cache-timed [time key data-thunk]
  (handle-cache 
    (fn [last-modified] (> (+ time last-modified) (current-time))) 
    key 
    data-thunk))

(defn handle-cache-indefinitely [key data-thunk]
  (handle-cache
    (fn [x] false)
    key
    data-thunk))