{:user {:plugins [[com.jakemccrary/lein-test-refresh "0.23.0"]
                  [cider/cider-nrepl "0.21.1"]
                  [jonase/eastwood "0.3.5"]
                  [lein-ancient "0.6.15"]
                  [lein-bikeshed "0.5.1"]
                  [lein-cljfmt "0.6.4"]
                  [lein-cloverage "1.1.1"]
                  [lein-kibit "0.1.6"]
                  [lein-nvd "0.6.0"]
                  [lein-try "0.4.3"]
                  [lein-typed "0.4.6"]
                  [venantius/yagni "0.1.7"]
                  ]
        :dependencies [[pjstadig/humane-test-output "0.9.0"]]
        :injections [(require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]
        :middleware [cider-nrepl.plugin/middleware]}
 :cljfmt {:remove-consecutive-blank-lines? false
          :indents {fdef [[:inner 0]]}}
 }
