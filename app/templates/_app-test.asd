(in-package :cl-user)
(defpackage <%= baseName %>-test-asd
  (:use :cl :asdf))
(in-package :<%= baseName %>-test-asd)

(defsystem <%= baseName %>-test
  :author ""
  :license ""
  :depends-on (:<%= baseName %>
               :cl-test-more)
  :components ((:module "t"
                :components
                ((:file "<%= baseName %>"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
