(ns clef-teacher.midi
  (:import (javax.sound.midi MidiDevice MidiSystem Receiver ShortMessage))
  (:require [clojure.string :as string]))

(def context (atom {}))
(def notes (atom {}))

(defn midi-to-octave [midi-num]
  (int (inc (/ (- midi-num 24) 12))))

(defn midi-to-notes
  ([midi-num] (midi-to-notes midi-num (rand-nth [:sharp :flat])))
  ([midi-num enharmonic]
   (let [sharp {0  "c"
                1  "c#"
                2  "d"
                3  "d#"
                4  "e"
                5  "f"
                6  "f#"
                7  "g"
                8  "g#"
                9  "a"
                10 "a#"
                11 "b"}
         flat {0  "c"
               1  "db"
               2  "d"
               3  "eb"
               4  "e"
               5  "f"
               6  "gb"
               7  "g"
               8  "ab"
               9  "a"
               10 "bb"
               11 "b"}]

     (str (get (if (= enharmonic :sharp) sharp flat)
               (mod (- midi-num 24) 12))
          (midi-to-octave midi-num)))))

(defn note-to-midi [note]
  (let [octave (:octave note)
        note-name (name (:note note))
        accidental (get {:sharp "#" :flat "b"} (:accidental note))
        index (get {"c"  0
                    "c#" 1
                    "db" 1
                    "d"  2
                    "d#" 3
                    "eb" 3
                    "e"  4
                    "f"  5
                    "f#" 6
                    "gb" 6
                    "g"  7
                    "g#" 8
                    "ab" 8
                    "a"  9
                    "a#" 10
                    "bb" 10
                    "b"  11
                    "cb" 11} (str note-name accidental))]
    (+ index (+ (* octave 12) 12))))

(def my-receiver (reify Receiver
                   (send [this mm timeStamp]
                     (when (instance? ShortMessage mm)
                       (let [sm (cast ShortMessage mm)]
                         (when (= ShortMessage/NOTE_ON (.getCommand sm))
                           (swap! notes assoc (.getData1 sm) :on))
                         (when (= ShortMessage/NOTE_OFF (.getCommand sm))
                           (swap! notes assoc (.getData1 sm) :off)))))))

(defn list-devices []
  (filter (fn [^MidiDevice x] (not= (.getName (.getDeviceInfo x)) "Real Time Sequencer")) (map #(MidiSystem/getMidiDevice %) (MidiSystem/getMidiDeviceInfo))))

(defn is-device-input [^MidiDevice dev]
  (or (= -1 (.getMaxTransmitters dev)) (> (.getMaxTransmitters dev) 0)))

(defn list-input-devices [^MidiDevice devices]
  (filter #(is-device-input %) devices))

(defn list-device-names [^MidiDevice devices]
  (map #(.getName (.getDeviceInfo %)) devices))

(defn get-device-by-name [^MidiDevice devices name]
  (first (filter #(= name (.getName (.getDeviceInfo %))) devices)))

(defn close-device []
  (.close (:device @context))
  (swap! context assoc :device nil))

(defn open-device [^MidiDevice device]
  (when (some? (:device @context))
    (close-device))
  (swap! context assoc :device device)
  (.open device)
  (.setReceiver (.getTransmitter device) my-receiver))

(defn parse-note [note-str]
  (let [note-name (keyword (string/lower-case (str (get note-str 0))))
        mod-1 (get note-str 1)
        mod-2 (get note-str 2)
        octave (parse-long (str (if-not (contains? (set '(\# \b)) mod-1) mod-1 mod-2)))
        accidental (if (contains? (set '(\# \b)) mod-1) mod-1 mod-2)]
    {:note note-name :octave octave :accidental (get {\# :sharp \b :flat} accidental)}))

(defn get-notes-state []
  (map #(parse-note (midi-to-notes %)) (keys (filter (fn [[k v]] (= :on v)) @notes))))

(defn get-open-device-name []
  (when (some? (:device @context))
    (.getName (.getDeviceInfo (:device @context)))))
