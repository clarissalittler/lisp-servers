(ql:quickload '(cl-who parenscript clack ningle lack))

(defpackage :text-list-server
  (:use :cl :cl-who))

(in-package :text-list-server)

(defparameter text-list nil)
(defparameter text-id 0)

(setf (html-mode) :html5)

(defparameter *app* (make-instance 'ningle:<app>))

(setf (ningle:route *app* "/") "Hey there I'm a default response")

(setf (ningle:route *app* "/texts/:id" :method :GET)
      #'(lambda (params)
	  (format nil "{value : ~a}" (assoc "id" params :test #'string=))))

(setf (ningle:route *app* "/texts/:id" :method :PUT) 
      #'(lambda (params)
	  (format t "body?: ~a" (lack.request:request-body-parameters ningle:*request*))
	  (format nil "{}")))

(setf (ningle:route *app* "/texts" :method :POST)
      #'(lambda (params)
	  (push (cons 'id text-id) text-list)
	  (incf text-id)
	  (format nil "{id : ~a}" (1- text-id)))) ; oh that's horrid style sorry

;;; so routes in ningle appear to be really similar to routes in something like Express
;;; let's try making this work with a little bit of backbone code that already exists

(defun path-selector (path)
  (if (find #\. path)
      path
      nil))

(setf *app* (lack:builder :accesslog (:static :path #'path-selector) *app*))

(clack:clackup *app*)
