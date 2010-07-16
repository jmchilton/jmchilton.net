(ns net.jmchilton.www.google
  (:use (net.jmchilton.www http)))

(def client-login-url "https://www.google.com/accounts/ClientLogin")

(defn- client-login-response [google-config]
  (let [params {:Email (:email google-config) 
                :Passwd (:password google-config)
                :service "reader" 
                :source "jmchilton-www-0.1" 
                :accountType "GOOGLE"}]
    (http-get client-login-url :query params)))

(defn- extract-auth [response-str]
  (let [start (+ 5 (.indexOf response-str "Auth="))
        end (.indexOf response-str "\n" start)]
    (.substring response-str start end)))

(defn- client-login-auth [google-config]
  (extract-auth
    (:content (client-login-response google-config))))

(defn get-google-auth-headers [google-config]
  (let [auth (client-login-auth google-config)]
    {"Authorization" (str "GoogleLogin auth=" auth)}))
