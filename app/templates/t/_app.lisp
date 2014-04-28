(in-package :cl-user)
(defpackage <%= baseName %>-test
  (:use :cl
        :<%= baseName %>
        :cl-test-more))
(in-package :<%= baseName %>-test)

(plan nil)

;; blah blah blah.

(finalize)
