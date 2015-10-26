(ql:quickload '(cl-who parenscript clack ningle lack))

(defparameter *app*
  (lambda (env)
    (format t "called~%")
    '(200 (:content-type "text/plain") ("Hello, World"))))

;;; Okay! I discovered that the reason why lack didn't seem to be working right is that,
;;; well, the documentation was a bit misleading. lack:builder returns a new app.
;;; the example on github makes it look like it statefully 
;;; modifies the app provided as an argument, when it actually operates more functionally.
;;; This all made a lot more sense once I macroexpand-1'ed lack:builder and saw that
;;; it outputs a fold of lambdas applying to the application argument.
;;; I'm going to include this file for reference in this repo.

(setf *app* (lack:builder
	     (:static :path "/public/"
		      :root #P"static-files/")
	     :accesslog
	     :backtrace
	     (lambda (app)
	       (lambda (env)
		 (format t "called from middle~%")
		 (funcall app env)))
	     *app*))

(clack:clackup *app*)
