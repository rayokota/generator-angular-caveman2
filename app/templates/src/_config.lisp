(in-package :cl-user)
(defpackage <%= baseName %>.config
  (:use :cl)
  (:import-from :envy
                :config-env-var
                :defconfig)
  (:export :config
           :*application-root*
           :*static-directory*
           :*template-directory*))
(in-package :<%= baseName %>.config)

(setf (config-env-var) "APP_ENV")

(defparameter *application-root*   (asdf:system-source-directory :<%= baseName %>))
(defparameter *static-directory*   (merge-pathnames #P"static/" *application-root*))
(defparameter *template-directory* (merge-pathnames #P"templates/" *application-root*))

(defconfig |development|
  `(:debug T
    <% if (orm == 'integral') { %>
    :database "my.db"
    <% } else { %>
    :database "my_db"
    :user "postgres"
    :password "postgres"
    :host "localhost"
    <% }; %>
   ))

(defconfig |production|
  `(:debug T
    <% if (orm == 'integral') { %>
    :database "my.db"
    <% } else { %>
    :database "my_db"
    :user "postgres"
    :password "postgres"
    :host "localhost"
    <% }; %>
   ))

(defun config (&optional key)
  (envy:config #.(package-name *package*) key))
