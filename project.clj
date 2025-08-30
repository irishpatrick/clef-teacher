(defproject clef-teacher "1.0.0"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "EPL-2.0 OR GPL-2.0-or-later WITH Classpath-exception-2.0"
            :url  "https://www.eclipse.org/legal/epl-2.0/"}
  :dependencies [[org.clojure/clojure "1.11.1"]
                 [org.slf4j/slf4j-log4j12 "2.0.17"]
                 [mount "0.1.23"]
                 [org.clojure/core.async "1.8.741"]
                 [http-kit "2.7.0"]
                 [compojure "1.7.1"]
                 [org.clojure/data.json "2.5.1"]
                 [ring/ring-json "0.5.1"]]
  :repl-options {:init-ns clef-teacher.core}
  :main clef-teacher.core
  :profiles {:uberjar {:aot      :all
                       :jvm-opts ["-Dclojure.compiler.direct-linking=true"]}})
