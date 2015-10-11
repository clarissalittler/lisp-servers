(ql:quickload '(cl-who hunchentoot))

(defpackage :counter-server 
  (:use :cl :cl-who :hunchentoot))

(in-package :counter-server)

(defparameter counter 0)

(setf (html-mode) :html5)

(defun main-page () 
  (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
    (:html 
     (:head 
      (:title "A Counter Example"))
     (:body 
      (:p (fmt "The counter is at ~d" counter))
      (:form :action "/inc" :method "post"
	     (:button "Click here!"))))))

(define-easy-handler (counter-page :uri "/") () 
    (main-page))

(define-easy-handler (counter-inc :uri "/inc") ()
    (incf counter)
    (redirect "/"))
