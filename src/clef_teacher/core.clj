(ns clef-teacher.core
  (:gen-class)
  (:require [mount.core :as mount]
            [clef-teacher.router :as api]))

(defn -main [& args]
  (api/register)
  (mount/start))