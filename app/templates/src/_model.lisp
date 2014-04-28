(in-package :cl-user)
(defpackage <%= baseName %>.model
  (:use :cl
        :integral)
  (:export :connect-to-db
           <% _.each(entities, function (entity) { %>:<%= entity.name %>
           <% _.each(entity.attrs, function (attr) { %>:<%= entity.name %>-<%=attr.attrName %>
           <% })}); %>
))
(in-package :<%=baseName %>.model)

(defvar *db-path* "my.db")

(defun initialize-db ()
  <% _.each(entities, function (entity) { %>(ensure-table-exists '<%= entity.name %>)
  <% }); %>
)

(defun connect-to-db ()
  (connect-toplevel :sqlite3 :database-name *db-path*)
  (initialize-db))

<% _.each(entities, function (entity) { %>
(defclass <%= entity.name %> ()
  ((id :type :integer
       :auto-increment t
       :primary-key t
       :not-null t)
   <% _.each(entity.attrs, function (attr) { %>
   (<%= attr.attrName %> :col-type <%= attr.attrImplType %>
       :initarg :<%= attr.attrName %> :accessor <%= entity.name %>-<%= attr.attrName %>)
   <% }); %>
  )
  (:metaclass <dao-table-class>))

  <% _.each(entity.attrs, function (attr) { %>
  <% if (attr.attrType == 'Boolean') { %> 
  (defmethod inflate ((object <%= entity.name %>) (slot-name (eql '<%= attr.attrName %>)) value)
    (if (eq value 1) t nil))

  (defmethod deflate ((object <%= entity.name %>) (slot-name (eql '<%= attr.attrName %>)) value)
    (if (eq value t) 1 0))
  <% }}); %>
<% }); %>

