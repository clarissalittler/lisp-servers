(ql:quickload '(clack ningle lack))

(defparameter text-list nil)
(defparameter text-id 0)

(defun list->jsarray (lst)
  (if lst 
      (with-output-to-string (s)
	(format s "[~a" (car lst))
	(dolist (i (cdr lst))
	  (format t ",~a" i)
	  (format s ",~a" (cdr i)))
	(format s "]"))
      "[]"))

(defparameter *app* (make-instance 'ningle:<app>))
(defparameter *server* nil)

(setf (ningle:route *app* "/") "Hey there I'm a default response")

(setf (ningle:route *app* "/texts/:id" :method :GET)
      #'(lambda (params)
	  (format nil "{value : ~a}" (assoc "id" params :test #'string=))))

(setf (ningle:route *app* "/texts/:id" :method :PUT) 
      #'(lambda (params)
	  (let ((id (cdr (assoc "id" params :test #'string=)))
		(val 
		  (cdr (assoc "value" 
			(lack.request:request-body-parameters ningle:*request*) :test #'string=))))
	    (setf (nth id text-list) (cons id val))
	    "{}")))

(setf (ningle:route *app* "/texts" :method :POST)
      #'(lambda (params)
	  (push (acons text-id "" nil) text-list)
	  (incf text-id)
	  (format nil "{\"id\" : ~a}" (1- text-id)))) ; oh that's horrid style sorry

(setf (ningle:route *app* "/texts" :method :GET)
      #'(lambda (params)
	  (list->jsarray text-list)))


;;; so routes in ningle appear to be really similar to routes in something like Express
;;; let's try making this work with a little bit of backbone code that already exists

(defun path-selector (path)
  (if (find #\. path)
      path
      nil))

(setf *app* (lack:builder :accesslog (:static :path #'path-selector) *app*))

(setf *server* (clack:clackup *app*))
