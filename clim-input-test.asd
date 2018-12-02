
(asdf:defsystem #:clim-input-test
  :description "A McCLIM Input Test Program"
  :author "Cyrus Harmon <ch-lisp@bobobeach.com>"
  :license  "BSD"
  :depends-on (:mcclim)
  :serial t
  :components ((:file "package")
               (:file "clim-input-test")
               (:file "clim-input-test-2")
               (:file "clim-input-test-3")))
