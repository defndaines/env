{:user {:plugins [[com.jakemccrary/lein-test-refresh "0.24.1"]
                  [cider/cider-nrepl "0.24.0"]
                  [com.livingsocial/lein-dependency-check "1.1.4"]
                  [lein-ancient "0.6.15"]
                  [lein-cljfmt "0.6.7"]
                  [lein-cloverage "1.1.2"]
                  [lein-nvd "1.3.1"]
                  [lein-try "0.4.3"]
                  [lein-zprint "0.5.4"]
                  [venantius/yagni "0.1.7"]]
        :injections [(require 'hashp.core)]
        :middleware [cider-nrepl.plugin/middleware]
        :dependencies [[clj-kondo "RELEASE"]
                       [hashp "0.1.1"]]
        ;; For testing older libraries:
        ; :java-cmd "/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home/bin/java"
        ; :java-cmd "/Library/Java/JavaVirtualMachines/jdk1.8.0_201.jdk/Contents/Home/bin/java"
        :aliases {"clj-kondo" ["run" "-m" "clj-kondo.main"]}}
 :cljfmt {:remove-consecutive-blank-lines? false
          :indents {fdef [[:inner 0]]}}}
