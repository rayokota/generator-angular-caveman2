(in-package :cl-user)
(defpackage <%= baseName %>.model
  (:use :cl
        :<%= orm %>)
  (:import-from :<%= baseName %>.config
                :config)
  (:export :connect-to-db
           <% _.each(entities, function (entity) { %>:<%= entity.name %>
           <% _.each(entity.attrs, function (attr) { %>:<%= entity.name %>-<%=attr.attrName %>
           <% })}); %>
))
(in-package :<%=baseName %>.model)

(defun initialize-db ()
  <% if (orm == 'integral') {%>
  <% _.each(entities, function (entity) { %>(ensure-table-exists '<%= entity.name %>)
  <% }); %>
  <% } else { %>
  <% _.each(entities, function (entity) { %>(if (not (table-exists-p '<%= entity.name %>)) (execute (dao-table-definition '<%= entity.name %>)))
  <% }); %>
  <% }; %>
)

(defun connect-to-db ()
  <% if (orm == 'integral') { %>
  (connect-toplevel :sqlite3 :database-name (getf (config) :database))
  <% } else { %>
  (connect-toplevel (getf (config) :database) (getf (config) :user) (getf (config) :password) (getf (config) :host))
  <% }; %>
  (initialize-db))

<% _.each(entities, function (entity) { %>
(defclass <%= entity.name %> ()
  <% if (orm == 'integral') { %>
  ((id :col-type integer
       :auto-increment t
       :primary-key t
       :not-null t)
  <% } else { %>
  ((id :col-type serial
       :init-arg :id)
  <% }; %>
   <% _.each(entity.attrs, function (attr) { %>
   (<%= attr.attrName %> :col-type <%= attr.attrImplType %>
       :initarg :<%= attr.attrName %> :accessor <%= entity.name %>-<%= attr.attrName %>)
   <% }); %>
  )
  <% if (orm == 'integral') { %>
  (:metaclass <dao-table-class>))
  <% } else { %>
  (:metaclass dao-class)
  (:keys id))
  <% }; %>

  <% _.each(entity.attrs, function (attr) { %>
  <% if (attr.attrType == 'Boolean') { %> 
  (defmethod inflate ((object <%= entity.name %>) (slot-name (eql '<%= attr.attrName %>)) value)
    (if (eq value 1) t nil))

  (defmethod deflate ((object <%= entity.name %>) (slot-name (eql '<%= attr.attrName %>)) value)
    (if (eq value t) 1 0))
  <% }}); %>
<% }); %>

