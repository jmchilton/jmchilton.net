
(define (make-crs which)
  (define eval-x (if (eq? () #f) (lambda (x) (eval x user-initial-environment)) eval))
  (define max-depth (if (number? which) which (apply max which)))
  (define (which? string)
    (or (and (number? which) (= which (string-length string)))
	(and (list? which)   (member (string-length string) which)))) 
  
  (define (make-for-string string)
    (let ((to-do-list (map (lambda (x) (if (eq? x #\d) 'cdr 'car)) (string->list string))))
      (lambda (sequence)
	(let ((result sequence))
	    (for-each (lambda (f) (set! result ((eval f) result))) (reverse to-do-list))
	      result))))

  (define (maker string depth)
    (if (which? string)
	(eval (list 'define (string->symbol (string-append "c" string "r")) (make-for-string string))))
    (if (not (= (string-length string) max-depth))
	(begin 
	         (maker (string-append string "d") (1+ depth))
		        (maker (string-append string "a") (1+ depth))))
    'done)  
  (maker "" 0))
