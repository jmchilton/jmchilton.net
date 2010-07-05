;;;; Break - A procedure for debugging
;;;; Author - John Chilton
;;;; Last Modified: 12/22/04
;;;;
;;;; Usage: Just place the line: (break (the-environment)) anywhere in
;;;; your STk code. When your procedure reaches this point, you will
;;;; be prompted to enter a variable name to inspect. After you press
;;;; enter the value of this variable in the called environment will
;;;; be displayed in the STk prompt, and you will be asked for a new
;;;; variable name. Just type continue or exit when you you are done
;;;; inspecting to resume execution of your code. When prompted you
;;;; can actually enter any scheme expression, not just a variable
;;;; name, and that expression will be evaluated in the envirnoment of
;;;; your procedures. Be careful not to use mutators as this will
;;;; change the environment of your procedure. To incorporate the STk
;;;; view command for a cons box diagram of your variable set the
;;;; global variable *break-use-view* to true, or when prompted for a
;;;; variable type (view variable), instead of variable. 
 

(define *break-use-view* #f)
(define *break-escape-codes* '(continue exit))

(define break (macro form (list 'break-helper (the-environment))))

(define (break-helper environment)
  (display (& "Enter variable to inspect (enter " 
	      (car *break-escape-codes*) " when done):"))
  (newline)
  (let ((to-check (read)))
    (cond ((member to-check *break-escape-codes*)
	   'done)
	  ((equal? to-check 'local)
	   (get-environment-diff environment))
	  ((or (and (symbol? to-check) (symbol-bound? to-check)) 
	       (list? to-check))
	   (display (eval to-check environment))
	   (newline)
	   (if *break-use-view*
	       (view (eval to-check environment)))
	   
	   (break environment))
	  (else
	   (display (& "Symbol " to-check 
		       "is unbound in this environment"))
	   (newline)
	   (break environment)))))

;;; Stuff below in progress, not yet implemented.
(define (get-environment-diff environment)
  (let* ((global-table (environment->list (global-environment)))
	 (env-table (environment->list environment))
	 (diff (set-diff env-table global-table)))
    diff))

(define (member-equal element l)
  (let ((contained #f))
    (for-each  (lambda (x) (if (equal? x element) (set! contained #t))) l)
    contained))

(define (set-diff l1 l2)
  (cond ((null? l1) ())
	((assoc (caar l1) l2) (set-diff (cdr l1) l2))
	(else (cons (car l1) (set-diff (cdr l1) l2)))))