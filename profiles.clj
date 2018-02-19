{:user {:plugins [[com.jakemccrary/lein-test-refresh "0.22.0"]
                  [jonase/eastwood "0.2.5"]
                  [lein-ancient "0.6.15"]
                  [lein-bikeshed "0.5.1"]
                  [lein-cljfmt "0.5.7"]
                  [lein-cloverage "1.0.10"]
                  [lein-kibit "0.1.6"]
                  [lein-try "0.4.3"]
                  [lein-typed "0.4.2"]]
        :dependencies [[pjstadig/humane-test-output "0.8.3"]]
        :injections [(require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]}
 :repl {:dependencies
        [^:displace [org.clojure/clojure "1.9.0"]]}
 :cljfmt {:remove-consecutive-blank-lines? false}}
