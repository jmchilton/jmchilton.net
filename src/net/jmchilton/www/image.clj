(ns net.jmchilton.www.image
  (:import (java.awt.image BufferedImage)
           (java.awt Color)
           (java.io ByteArrayInputStream ByteArrayOutputStream))
  (:use (net.jmchilton.www cache)))

(defn- partition-uri [uri]
  (map #(seq (.split % "x")) (seq (.split uri "-"))))

(defn- as-int [hex]
  (Integer/parseInt (.toUpperCase (apply str hex)) 16))

(defn- get-color [partition]
  (apply #(Color. %1 %2 %3) (map as-int (clojure.core/partition 2 (first partition)))))

(defn- get-length [partition]
  (Integer/parseInt (second partition)))

(defn- buffered-image->byte-array [buffered-image]
  (let [output-stream (ByteArrayOutputStream.)]
    (javax.imageio.ImageIO/write buffered-image "png" output-stream)
    (.toByteArray output-stream)))

(defn get-image-raw [uri]
  (let [rest-uri (.substring uri (+ 2 (.indexOf uri "bg")) (.indexOf uri ".png"))
        partitioned-uri (partition-uri rest-uri)
        total-length (apply + (map get-length partitioned-uri))
        buffered-image (BufferedImage. 1 total-length (BufferedImage/TYPE_INT_RGB))
        graphics (.createGraphics buffered-image)]
    (.setPaintMode graphics)
    (loop [accum-length 0
           partitions partitioned-uri]
      (if (not (nil? partitions))
        (let [partition (first partitions)
              length (get-length partition)
              color (get-color partition)]
          (doto graphics
            (.setColor color)
            (.drawLine 0 accum-length 0 (+ accum-length length)))
          (recur (+ accum-length length) (next partitions)))))
    (buffered-image->byte-array buffered-image)))

(defn get-image [uri]
  (ByteArrayInputStream. (handle-cache-indefinitely uri (fn [] (get-image-raw uri)))))