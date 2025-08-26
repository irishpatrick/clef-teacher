;(ns clef-teacher.fx
;  (:require [cljfx.api :as fx]
;            [clojure.math :as math]
;
;            [clef-teacher.linear-math :as lm])
;  (:import (javafx.scene.canvas Canvas GraphicsContext)
;           (javafx.scene.paint Color)
;           (javafx.scene.shape ArcType)))
;
;
;(def staff-config {:lines         5
;                   :line-y-offset 1
;                   :line-weight   2
;                   :x             100
;                   :y             100
;                   :width         300
;                   :height        100})
;
;
;(def PI 3.14159)
;
;
;(defn get-line-y [idx cfg]
;  (+ (:line-weight cfg)
;     (* idx
;        (/ (- (:height cfg) (:line-y-offset cfg)) (:lines cfg)))))
;
;
;(defn ellipse [a b n]
;  (map #(vector (* a (math/cos %)) (* b (math/sin %))) (map #(* (* 2.0 PI) (/ % n)) (range 0 (inc n)))))
;
;
;(defn draw-flat [^GraphicsContext ctx x y unit]
;  (let [ox x
;        oy (+ y (* 0.175 unit))]
;    (doto ctx
;      (.moveTo ox oy)
;      (.lineTo ox (- oy unit))
;      (.moveTo ox oy)
;      (.bezierCurveTo (+ ox (* 0.4 unit)) (- oy (* 0.1 unit))
;                      (+ ox (* 0.5 unit)) (- oy (* 0.2 unit))
;                      ox (- oy (* 0.35 unit)))
;      (.stroke))))
;
;
;(defn draw-sharp [^GraphicsContext ctx x y unit]
;  (let [step (* unit 0.15)
;        half (* unit 0.4)
;        skew (* unit 0.1)]
;    (doto ctx
;      (.moveTo (- x (- step skew)) (- y half))
;      (.lineTo (- x step skew) (+ y half))
;      (.moveTo (+ x step skew) (- y half))
;      (.lineTo (+ x (- step skew)) (+ y half))
;      (.moveTo (- x half) (- y step))
;      (.lineTo (+ x half) (- y step))
;      (.moveTo (- x half) (+ y step))
;      (.lineTo (+ x half) (+ y step))
;      (.stroke))))
;
;(defn draw-circle [^GraphicsContext ctx x y radius]
;  (.fillArc ctx (- x radius) (- y radius) (* 2 radius) (* 2 radius) 0 360 ArcType/CHORD))
;
;
;(defn draw-bass-clef [^GraphicsContext ctx cfg unit]
;  (doto ctx
;    (.moveTo (:x cfg) (+ (:y cfg) (get-line-y 1 cfg)))
;    (.bezierCurveTo (:x cfg) (- (:y cfg) 5) (+ (:x cfg) 5) (:y cfg) (+ (:x cfg) unit) (:y cfg))
;    (.bezierCurveTo (+ (:x cfg) unit) (+ (:y cfg) unit) (+ (:x cfg) unit) (- (+ (:y cfg) (get-line-y 3 cfg)) unit) (:x cfg) (+ (:y cfg) (get-line-y 3 cfg)))
;    (draw-circle (+ unit (:x cfg)) (+ (:y cfg) (get-line-y 0.5 cfg)) 5)
;    (draw-circle (+ unit (:x cfg)) (+ (:y cfg) (get-line-y 1.5 cfg)) 5)))
;
;
;(defn draw-note-shape [^GraphicsContext ctx x y unit]
;  (let [w (* 0.3 unit)
;        h (* 0.2 unit)
;        sh -0.5
;        polygon (lm/translate-polygon (lm/shear-polygon (ellipse w h 100) sh) x y)]
;    (doto ctx
;      (.fillPolygon (into-array Double/TYPE (map #(first %) polygon)) (into-array Double/TYPE (map #(second %) polygon)) (count polygon))
;      (.setLineWidth 2)
;      (.moveTo (+ x w) y)
;      (.lineTo (+ x w) (- y (* unit 1)))
;      (.stroke))))
;
;
;(defn get-line [idx cfg]
;  (let [height (+ (:y cfg) (get-line-y idx cfg))
;        width (:width cfg)]
;    [(:x cfg) height (+ (:x cfg) width) height]))
;
;
;(defn draw-line [ctx pts]
;  (.moveTo ctx (get pts 0) (get pts 1))
;  (.lineTo ctx (get pts 2) (get pts 3)))
;
;
;
;(defn note-to-line [note]
;  (+ (* -3.5 (- (:octave note) 4)) (get {:a 2.5 :b 2 :c 5 :d 4.5 :e 4 :f 3.5 :g 3} (:note note))))
;
;
;(defn draw-note [ctx note cfg ox oy]
;  (let [x (+ (:x cfg) ox)
;        y (+ (:y cfg) oy (get-line-y (note-to-line note) cfg))
;        unit 30]
;    (doto ctx
;      (draw-note-shape x y unit))
;    (when (= :sharp (:accidental note)) (draw-sharp ctx (- x unit) y unit))
;    (when (= :flat (:accidental note)) (draw-flat ctx (- x unit) y unit))))
;
;
;(defn draw-staff [note-seq & {:keys [clef width height]}]
;  {:fx/type :canvas
;   :width   width
;   :height  height
;   :draw    (fn [^Canvas canvas]
;              (doto (.getGraphicsContext2D canvas)
;                (.clearRect 0 0 width height)
;                (.setStroke Color/BLACK)
;                (.setLineWidth 1.2)
;                (draw-line (get-line 0 staff-config))
;                (draw-line (get-line 1 staff-config))
;                (draw-line (get-line 2 staff-config))
;                (draw-line (get-line 3 staff-config))
;                (draw-line (get-line 4 staff-config))
;                (draw-bass-clef staff-config 30)
;                (draw-note (parse-note "c#4") staff-config 30 0)
;                (draw-note (parse-note "f4") staff-config 30 0)
;                (draw-note (parse-note "Bb5") staff-config 60 0)
;                (.stroke)))})
;
;
;(defn fx-main [& args]
;  (fx/on-fx-thread
;    (fx/create-component
;      {:fx/type :stage
;       :showing true
;       :title   "Cljfx example"
;       :width   512
;       :height  480
;       :scene   {:fx/type :scene
;                 :root    {:fx/type   :v-box
;                           :alignment :center
;                           :children  [{:fx/type :label
;                                        :text    "Hello world"}
;                                       (draw-staff [] :width 512 :height 480)]}}})))