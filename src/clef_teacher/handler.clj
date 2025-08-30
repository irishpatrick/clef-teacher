(ns clef-teacher.handler
  (:require [clef-teacher.midi :as midi]
            [clef-teacher.scores :as scores]
            [clojure.data.json :as json]))

(defn get-status [req]
  "ok")

(defn get-devices [req]
  (let [names (midi/list-device-names (midi/list-input-devices (midi/list-devices)))
        sorted-names (sort (fn [a b] (= a (midi/get-open-device-name))) names)]
    {:headers {"Content-Type" "application/json"}
     :body    (json/write-str sorted-names)}))

(defn connect-device [req]
  (let [params (:params req)]
    (midi/open-device (midi/get-device-by-name (midi/list-input-devices (midi/list-devices)) (get params "device")))
    {:status 200}))

(defn get-notes [req]
  {:headers {"Content-Type" "application/json"}
   :body    (json/write-str (midi/get-notes-state))})

(defn get-random-note [req]
  (let [params (:query-params req)
        min (midi/note-to-midi (midi/parse-note (or (get params "lower") "a0")))
        max (midi/note-to-midi (midi/parse-note (or (get params "upper") "c8")))
        choice (+ min (rand-int (- max min)))]
    {:headers {"Content-Type" "application/json"}
     :body    (json/write-str (midi/parse-note (midi/midi-to-notes choice)))}))

(defn get-highest-score [req]
  {:headers {"Content-Type" "application/json"}
   :body    (json/write-str (scores/get-highest-score))})

(defn update-high-score [req]
  (let [params (:params req)
        name (get params "name")
        score (get params "score")]
    (if (not (and (some? name) (some? score)))
      {:status 400}
      (do
        (scores/set-high-score name score)
        {:status 200}))))
