(ns clef-teacher.linear-math)


(defn shear [m]
  [[1 0] [m 1]])

(defn transpose [m]
  (let [fm (vec (flatten m))]
    (vec (map #(vector (get fm %) (get fm (+ 2 %))) [0 1]))))


(defn dot [a b]
  (if (and (seq a) (seq b))
    (+ (* (first a) (first b)) (dot (rest a) (rest b)))
    0))

(defn mat-vec-mul [m v]
  (let [mt (transpose m)]
    [(dot (first mt) v) (dot (last mt) v)]))

(defn shear-polygon [polygon m]
  (map #(mat-vec-mul (shear m) %) polygon))



(defn translate-polygon [polygon x y]
  (map #(vector (+ x (first %)) (+ y (second %))) polygon))