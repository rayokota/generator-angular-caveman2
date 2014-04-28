(in-package :cl-user)
(defpackage <%= baseName %>.web
  (:use :cl
        :caveman2
        :integral
        :json
        :<%= baseName %>.config
        :<%= baseName %>.model
        :<%= baseName %>.view)
  (:export :*web*))

(in-package :json)

(defmethod encode-json ((o standard-object)
                        &optional (stream json:*json-output*))
  "Write the JSON representation (Object) of the DAO CLOS object
O to STREAM (or to *JSON-OUTPUT*)."
  (with-object (stream)
    (map-slots (lambda (key value)
                 (if (string= (format nil "~A" key) "%SYNCED")
                     value
                 (as-object-member (key stream)
                   (encode-json (if (eq value :null) nil value) stream))))
               o)))

(in-package :<%= baseName %>.web)

;;
;; Application

(defclass <web> (<app>) ())
(defparameter *web* (make-instance '<web>))

;;
;; Routing rules

(defroute "/" ()
  (redirect "index.html"))

<% _.each(entities, function (entity) { %>
(defroute ("/<%= baseName %>/<%= pluralize(entity.name) %>" :method :GET) ()
  (setf (headers *response* :content-type) "application/json")
  (json:encode-json-to-string (select-dao '<%= entity.name %>)))

(defroute ("/<%= baseName %>/<%= pluralize(entity.name) %>/:id" :method :GET) (&key id)
  (setf (headers *response* :content-type) "application/json")
  (json:encode-json-to-string (find-dao '<%= entity.name %> id)))

(defroute ("/<%= baseName %>/<%= pluralize(entity.name) %>" :method :POST) ()
  (let* ((json (getf (getf (clack.request:env *request*) :body-parameters) :json))
    <% _.each(entity.attrs, function (attr) { %>(<%= attr.attrName %> (gethash "<%= attr.attrName %>" json))
    <% }); %>
  )
    (let ((entity (create-dao '<%= entity.name %>
                              <% _.each(entity.attrs, function (attr) { %>:<%= attr.attrName %> <%= attr.attrName %>
                              <% }); %>
    )))
      (setf (headers *response* :content-type) "application/json")
      (setf (status *response*) 201)
      (json:encode-json-to-string entity))))

(defroute ("/<%= baseName %>/<%= pluralize(entity.name) %>/:id" :method :PUT) (&key id)
  (let* ((json (getf (getf (clack.request:env *request*) :body-parameters) :json))
    <% _.each(entity.attrs, function (attr) { %>(<%= attr.attrName %> (gethash "<%= attr.attrName %>" json))
    <% }); %>
  )
    (let ((entity (find-dao '<%= entity.name %> id)))
      <% _.each(entity.attrs, function (attr) { %>(setf (<%= entity.name %>-<%= attr.attrName %> entity) <%= attr.attrName %>)
      <% }); %>
      (save-dao entity)
      (setf (headers *response* :content-type) "application/json")
      (json:encode-json-to-string entity))))

(defroute ("/<%= baseName %>/<%= pluralize(entity.name) %>/:id" :method :DELETE) (&key id)
  (let ((entity (find-dao '<%= entity.name %> id)))
    (delete-dao entity)
    (setf (status *response*) 204)
    ""))
<% }); %>

; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
