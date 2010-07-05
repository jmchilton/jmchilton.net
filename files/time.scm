;; Written by: John Chilton ( chil0060@umn.edu ) 
;; Last Modified:  1/30/2005 

;; Usage: (time <scheme expression>)

;; Description: Code to replace STk's builtin time function which
;; doesn't work properly on Solaris with version 4.0.1 of STk,
;; displays an expressions runtime and returns the value of the
;; expression.  

 
;; Load C Library functions for timing.
;; This code assumes you are on the U of M ITLabs domain
(define-external begin_timing() :return-type :double :entry-name "start_calc" :library-name "/web/classes03/Spring-2005/csci1901/files/libcalctime")
(define-external end_timing() :return-type :double :entry-name "end_calc" :library-name "/web/classes03/Spring-2005/csci1901/files/libcalctime")



(define (display-time usecs)
  (display "\;\; Time: ")
  (display (/ (round (* (expt 10 5) usecs)) (expt 10 2)))
  (display " ms\n"))

(define time (macro form `(begin (begin_timing) (let ((result  ,(cadr form))) (display-time (end_timing)) result))))


;;;Timing test
(define (time_test)
  (define (fib x) (if (< x 2) 1 (+ (fib (- x 1)) (fib (- x 2)))))
  (dotimes (i 30)
	   (display  (time (fib i)))
	   (newline)))