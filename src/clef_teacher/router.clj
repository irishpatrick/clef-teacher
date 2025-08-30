(ns clef-teacher.router
  (:use [compojure.route :only [files not-found]]
        [compojure.core :only [defroutes GET POST DELETE ANY context]]
        [org.httpkit.server])
  (:require [mount.core :refer [defstate]]
            [clef-teacher.handler :as handler]
            [ring.middleware.json :as json-mw]
            [ring.middleware.params :as param-mw]))

(defonce server (atom nil))

(defroutes routes
           (GET "/api/status" [] handler/get-status)
           (GET "/api/devices" [] handler/get-devices)
           (POST "/api/devices/connect" [] (json-mw/wrap-json-params handler/connect-device))
           (POST "/api/high-score" [] (json-mw/wrap-json-params handler/update-high-score))
           (GET "/api/high-score" [] handler/get-highest-score)
           (GET "/api/poll/notes" [] handler/get-notes)
           (GET "/api/random-note" [] (param-mw/wrap-params handler/get-random-note)))

(defn stop []
  (println "stop api")
  (when-not (nil? @server)
    (@server :timeout 100)
    (reset! server nil)))

(defn start []
  (println "start api")
  (.addShutdownHook (Runtime/getRuntime) (Thread. (fn [] (stop))))
  (reset! server (run-server routes {:port 5050})))

(declare conn)
(defn register []
  (defstate conn :start (start) :stop (stop)))