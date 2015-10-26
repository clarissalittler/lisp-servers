(ql:quickload '(cl-who parenscript clack ningle lack))

(defpackage :text-list-server
  (:use :cl :cl-who))

(in-package :text-list-server)

(defparameter text-list nil)

(setf (html-mode) :html5)

(defvar *app* (make-instance 'ningle:<app>))

;;; so routes in ningle appear to be really similar to routes in something like Express
;;; let's try making this work with a little bit of backbone code that already exists

(lack:builder (:static :path "/") *app*)

(clack:clackup *app*)
