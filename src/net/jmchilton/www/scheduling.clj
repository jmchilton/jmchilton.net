(ns net.jmchilton.www.scheduling
  (:use (net.jmchilton.www utils)))

(import 'java.util.Timer)
(import 'java.util.TimerTask)

;; Following definitions enable cool calls like (every 5 hours) with periodically-send-off
(def every *)
(def seconds 1000)
(def minutes (* seconds 60))
(def hours (* minutes 60))
(def days (* hours 24))

(def #^Timer timer (Timer. true)) ; Create a deamon thread for updating.

(defn agent-cache [x] (agent {:content x :updated (current-time)}))

(defn periodically-send-off [agent period function & args]
  (let [#^TimerTask task-proxy (proxy [TimerTask] []
                                 (run []
                                   (apply send-off (concat [agent function] args))))
        delay 1]
    (.scheduleAtFixedRate timer task-proxy (long delay) (long period))))

(defn periodically-update
  ([agent period thunk] (periodically-update agent period (fn [& args] true) thunk))
  ([agent period predicate thunk]
    (periodically-send-off agent period
      (fn [agent-value]
        (let [content (:content agent-value)
              updated (:updated agent-value)]
          (if (predicate updated)
              {:content (thunk) :updated (current-time)}
              agent-value))))))


