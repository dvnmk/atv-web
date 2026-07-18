(asdf:defsystem "atv-web"
  :version "0.1.0"
  :author "your-name"
  :license "MIT"
  :depends-on (
	       "hunchentoot"
	       "dexador"
               )
  :components
  ((:file "package")
   (:file "magic-word")
   (:file "atv-web")
   )
  )

