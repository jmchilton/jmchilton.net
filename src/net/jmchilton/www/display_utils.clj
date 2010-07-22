(ns net.jmchilton.www.display-utils)
;;;; Generic utilities that are related to displaying data to the user.

(def display-date-formatter (java.text.SimpleDateFormat. "EEE, dd-MMM-yyyy HH:mm"))

(defmulti format-date class)
(defmethod format-date java.util.Calendar [date] (format-date (.getTime date)))
(defmethod format-date java.util.Date [date] (format-date (.getTime date)))
(defmethod format-date Long [date] (.format display-date-formatter date))
