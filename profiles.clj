{:user {:plugins [[com.jakemccrary/lein-test-refresh "0.23.0"]
                  [cider/cider-nrepl "0.18.0"]
                  [jonase/eastwood "0.3.1"]
                  [lein-ancient "0.6.15"]
                  [lein-bikeshed "0.5.1"]
                  [lein-cljfmt "0.6.1"]
                  [lein-cloverage "1.0.13"]
                  [lein-kibit "0.1.6"]
                  [lein-try "0.4.3"]
                  [lein-typed "0.4.6"]
                  [venantius/yagni "0.1.4"]
                  ]
        :dependencies [[pjstadig/humane-test-output "0.8.3"]]
        :injections [(require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]}
 :repl {:dependencies
        [^:displace [org.clojure/clojure "1.10.0-beta3"]]}
 :cljfmt {:remove-consecutive-blank-lines? false
          :indents {fdef [[:inner 0]]}}
}
