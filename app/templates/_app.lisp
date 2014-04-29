(ql:quickload :<%= baseName %>)

(defpackage <%= baseName %>.app
  (:use :cl)
  (:import-from :clack.builder
                :builder)
  <% if (orm != 'integral') { %>(:import-from :clack.middleware.postmodern
                :<clack-middleware-postmodern>)<% }; %>
  (:import-from :clack.middleware.static
                :<clack-middleware-static>)
  (:import-from :clack.middleware.session
                :<clack-middleware-session>)
  (:import-from :clack.middleware.backtrace
                :<clack-middleware-backtrace>)
  (:import-from :ppcre
                :scan
                :regex-replace)
  (:import-from :osicat
                :environment-variable)
  (:import-from :<%= baseName %>.model
                :connect-to-db)
  (:import-from :<%= baseName %>.web
                :*web*)
  (:import-from :<%= baseName %>.config
                :config
                :*static-directory*))
(in-package :<%= baseName %>.app)

(symbol-macrolet ((appenv (environment-variable "APP_ENV")))
  (unless appenv
    (setf appenv "default")))

(connect-to-db)

(builder
 (<clack-middleware-static>
  :path (lambda (path)
          (if (ppcre:scan "^(?:/index\.html$|/css/|/js/|/lib/|/views/|/robot\\.txt$|/favicon.ico$)" path)
              path
              nil))
  :root *static-directory*)
 (if (getf (config) :error-log)
     (make-instance '<clack-middleware-backtrace>
                    :output (getf (config) :error-log))
     nil)
 <clack-middleware-session>
 <% if (orm != 'integral') { %>(<clack-middleware-postmodern>
  :database (getf (config) :database)
  :user (getf (config) :user)
  :password (getf (config) :password)
  :host (getf (config) :host))<% }; %>
 *web*)
