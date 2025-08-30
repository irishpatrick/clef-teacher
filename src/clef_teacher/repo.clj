(ns clef-teacher.repo
  (:require [clojure.edn :as edn]
            [clojure.java.io :as io])
  (:import (java.io File)))

(def high-score-file "./test.edn")

(defn load-high-scores [^String fn]
  (try
    (.createNewFile (File. fn))
    (catch Exception e))
  (or (edn/read-string (slurp fn)) {}))

(defn save-high-scores [^String fn score-map]
  (with-open [w (io/writer fn)]
    (.write w (str score-map))
    score-map))

