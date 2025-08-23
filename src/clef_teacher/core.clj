(ns clef-teacher.core
  (:require [mount.core :as mount]
            [clef-teacher.router :as api]))

(defn -main [& args]
  (api/register)
  (mount/start))