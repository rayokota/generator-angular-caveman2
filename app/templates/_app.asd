(in-package :cl-user)
(defpackage <%= baseName %>-asd
  (:use :cl :asdf))
(in-package :<%= baseName %>-asd)

(defsystem <%= baseName %>
  :version "0.1"
  :author ""
  :license ""
  :depends-on (:clack
               :caveman2
               :envy
               :osicat
               :cl-ppcre

               ;; HTML Template
               :cl-emb

               ;; for rendering JSON
               :cl-json
               :yason
               :trivial-types

               ;; for ORM
               :integral)
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config"))
                 (:file "web" :depends-on ("model" "view"))
                 (:file "view" :depends-on ("config"))
                 (:file "model")
                 (:file "config"))))
  :description ""
  :in-order-to ((test-op (load-op <%= baseName %>-test))))
