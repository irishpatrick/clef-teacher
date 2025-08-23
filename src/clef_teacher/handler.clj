(ns clef-teacher.handler
  (:require [clef-teacher.midi :as midi]
            [clojure.data.json :as json]))

(defn get-status [req]
  "ok")

(defn get-devices [req]
  {:headers {"Content-Type" "application/json"}
   :body (json/write-str (midi/list-device-names (midi/list-input-devices (midi/list-devices))))})

(defn connect-device [req]
  (let [params (:params req)]
    (midi/open-device (midi/get-device-by-name (midi/list-input-devices (midi/list-devices)) (get params "device")))
    {:status 200}))

(defn get-notes [req]
  {:headers {"Content-Type" "application/json"}
   :body (json/write-str (midi/get-notes-state))})
