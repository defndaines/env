{:user {:plugins [[com.jakemccrary/lein-test-refresh "0.24.1"]
                  [cider/cider-nrepl "0.22.4"]
                  [jonase/eastwood "0.3.6" :exclusions [org.clojure/clojure]]
                  [lein-ancient "0.6.15"]
                  [lein-bikeshed "0.5.2" :exclusions [org.clojure/tools.cli]]
                  [lein-cljfmt "0.6.6"]
                  [lein-cloverage "1.1.2"]
                  [lein-kibit "0.1.8"]
                  [lein-nvd "1.3.1"]
                  [lein-try "0.4.3"]
                  [lein-typed "0.4.6"]
                  [venantius/yagni "0.1.7"]
                  ]
        :middleware [cider-nrepl.plugin/middleware]
        :dependencies [[clj-kondo "RELEASE"]]
        ;; For testing older libraries:
        ; :java-cmd "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/bin/java"
        :aliases {"clj-kondo" ["run" "-m" "clj-kondo.main"]}}
 :cljfmt {:remove-consecutive-blank-lines? false
          :indents {fdef [[:inner 0]]}}
 }
