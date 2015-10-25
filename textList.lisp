(ql:quickload '(cl-who parenscript clack ningle))

(defpackage :text-list-server
  (:use :cl :cl-who))

(in-package :text-list-server)

(defparameter text-list nil)
(defparameter )

(setf (html-mode) :html5)

(defvar *app* (make-instance 'ningle:<app>))

(defun file->string (filename)
  (with-open-file (f filename)
    (with-output-to-string (out)
      (loop for line = (read-line f nil 'foo)
	   until (eq line 'foo)
	   do (write-line line out)))))

;;; so routes in ningle appear to be really similar to routes in something like Express
;;; let's try making this work with a little bit of backbone code that already exists

(setf (ningle:route *app* "/")
      (file->string "textlistServe.html"))

(setf (ningle:route *app* ))
