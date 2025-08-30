(ns clef-teacher.scores
  (:require [clef-teacher.repo :as repo]))

(defn set-high-score [player score]
  (repo/save-high-scores repo/high-score-file
                         (assoc (repo/load-high-scores repo/high-score-file)
                           player
                           score)))

(defn get-high-score [player]
  (or (get (repo/load-high-scores repo/high-score-file) player) 0))

(defn largest
  ([comp-fn items] (largest comp-fn (rest items) (first items)))
  ([comp-fn items largest-seen]
   (if (not (seq items))
     largest-seen
     (if (> (comp-fn largest-seen (first items)) 0)
       (largest comp-fn (rest items) largest-seen)
       (largest comp-fn (rest items) (first items))))))

(defn get-highest-score []
  (let [[name score] (largest #(- (second %1) (second %2)) (seq (repo/load-high-scores repo/high-score-file)))]
    {:name name :score score}))
