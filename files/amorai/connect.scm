;;;; connect.scm - Written by John Chilton (chilton at cs dot umn.edu;;;;
;;;; This file contains procedures to interact with a Sony AIBO
;;;; running AMORAI. 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Defined constants

;; Set the dog's IP address
(define *dog-addr* "192.168.1.201")

(define *read-world-state* #f)

;; Port Numbers 
(define *led-port* 13001)
(define *ear-port* 13004)
(define *posture-port* 13003)
(define *joint-port* 13005)
(define *output-port* 13010)
(define *walk-port* 13002)
(define *sound-port* 13011)
(define *world-state-port* 13101)
(define *lock-output-port* 13012)

(define *output-led-offset* 18) 
(define *output-ear-offset* 45)
(define *output-joint-offset* 0)

;; Assign names for joints
(define *output-names*
  '(leg-left-front-rotator leg-left-front-elevator leg-left-front-knee 
    leg-right-front-rotator leg-right-front-elevator leg-right-front-knee
    leg-left-back-rotator leg-left-back-elevator leg-left-back-knee
    leg-right-back-rotator leg-right-back-elevator leg-right-back-knee
    head-tilt head-pan head-nod
    tail-tilt tail-pan
    mouth
    led-head-color  led-head-white
    led-mode-r led-mode-g led-mode-b
    led-wireless
    led-face-a led-face-b led-face-c led-face-d led-face-e 
    led-face-f led-face-g led-face-h led-face-i led-face-j 
    led-face-k led-face-l led-face-m led-face-n
    led-back-front-color  led-back-front-white
    led-back-middle-color led-back-middle-white
    led-back-rear-color led-back-rear-white
    led-ab-mode
    ear-left ear-right))

(define num-outputs (length *output-names*))
(define reset-output-number num-outputs) ; at the end

(define *the-world-state* '())

;; Define constants for joints and leds
(map (lambda (key value) (primitive-eval (list 'define key value)))
     *output-names*
     (iota (length *output-names*)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; AMORAI/AIBO socekt communication procedures

;; Creates a AF_INET socket and connects to addr on given port.
(define make-aibo-socket ;; Need to add error checking
  (lambda (addr port)
    (catch 
     'system-error
     (lambda ()
       (let ((sock (socket AF_INET SOCK_STREAM 0)))
	 (connect sock AF_INET (inet-aton addr) port)
	 sock))
     (lambda (. args)
      (let ((errno (system-error-errno args)))
	(display "Error connecting to AIBO socket: ")
	(display (strerror errno))
	(newline))))))

;; Data structure for connecting to AIBO. A list containing the
;; socket, the port number, and whether it is a fixed length or
;; variable length communication pattern.
(define make-aibo-comm
  (lambda (address port fixed)
    (list (make-aibo-socket address port) (exact->binary port) fixed)))

;; Write a message to an AIBO comm.
(define write-to-aibo
  (lambda (aibo-comm msg)
    (let* ((binary-port (cadr aibo-comm))
	   (fixed (caddr aibo-comm))
	   (len-str (if fixed "" (exact->binary (string-length msg)))))
      (send (car aibo-comm) (string-append binary-port len-str msg)))))

;; Reads from an AIBO comm.
(define read-from-aibo 
  (lambda (aibo-comm bytes)
    (let* ((binary-port (cadr aibo-comm))
	   (buf (make-string bytes #\0))
	   (bytes-read (recv! (car aibo-comm) buf)))
      (cons bytes-read buf))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Procedures for reading/writing binary data

;;; Quick code for creating binary data in Guile     
;;; prototype       type                            printing character
;;; #t              boolean (bit-vector)                    b
;;; #\a             char (string)                           a
;;; integer >0      unsigned integer                        u
;;; integer <0      signed integer                          e
;;; 1.0             float (single precision)                s
;;; 1/3             double (double precision float)         i
;;; +i              complex (double precision)              c
;;; ()              conventional vector

(define list->binary 
  (lambda (prototype lst)
    (with-output-to-string
      (lambda ()
	(uniform-vector-write (list->uniform-vector prototype lst))))))

(define 64-bit->32-bit
  (lambda (data)
    (apply string-append
	   (map (lambda (i) (substring data (* i 8) (+ (* i 8) 4))) 
		(iota (/ (string-length data) 8))))))
  
(define exact->binary
  (lambda (. exacts)
    (let ((raw (list->binary -1 exacts)))
      (if (= (length exacts) (/ (string-length raw) 4))
	  raw
	  (64-bit->32-bit raw)))))

(define inexact->binary
  (lambda (. inexacts)
    (list->binary 1.0 inexacts)))

(define binary->vector
  (lambda (prototype-lst buf)
    (with-input-from-string buf
      (lambda ()
	(define read-buf
	  (lambda (prototype num)
	    (let ((v (make-uniform-vector num prototype)))
	      (uniform-vector-read! v)
	      (map (lambda (x) (uniform-vector-ref v x)) (iota num)))))
	(list->vector (apply append (map (lambda (x) (read-buf (car x) (cdr x)))
prototype-lst)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Low-level commands 

;; Sets given outputs (leds and joints) to given values, see top of
;; file for possible ids.
(define output-maker
  (lambda (comm)
    (lambda (output-ids output-vals)
      (write-to-aibo
       comm
       (string-append (apply exact->binary output-ids)
		      (apply inexact->binary output-vals))))))


(define write-output
  (lambda (output-id output-val)
    (write-outputs (list output-id) (list output-val))))

;(define lock-output
;  (lambda (output-id output-val)
;    (lock-outputs (list output-id) (list output-val))))

;(define reset-output-lock
;  (lambda () 
;    (lock-output reset-output-number 1.0)))



;; Makes procedures for quick writing to outputs.
(define write-output-maker
  (lambda (offset)
    (lambda (keys vals)
      (write-outputs (map (lambda (x) (+ x offset)) keys) vals))))

(define write-led-raw (write-output-maker *output-led-offset*))
(define write-joint-raw (write-output-maker *output-joint-offset*))
(define write-ear-raw (write-output-maker *output-ear-offset*))

;; Command AIBO to move. Try to keep values from 0 to 1.
(define write-walk
  (lambda (x y a) ;; Forward, Strafe, Rotate
    (let ((walk-msg (inexact->binary x y a)))
      (write-to-aibo *walk-comm*  walk-msg))))

(define write-ears
  (lambda (l r)
    (let ((ear-msg (inexact->binary l r)))
      (write-to-aibo *walk-comm* ear-msg))))

;; Command AIBO to walk forward.
(define walk
  (lambda (x)
    (write-walk x 0 0)))

;; Command AIBO to rotate
(define rotate
  (lambda (a)
    (write-walk 0 0 a)))

;; Command AIBO to strafe (move to the side).
(define strafe
  (lambda (y)
    (write-walk 0 y 0)))

;; Stops the dog
(define stop
  (lambda ()
    (write-walk 0 0 0)))

;; Commands AIBO to execute .pos file. I'm not sure what num is for,
;; might be duration over which posture executes.
(define write-posture
  (lambda (num file)
    (let* ((upper-file (string-downcase file))
	   (extension (if (string-match ".pos" file) "" ".pos"))
	   (outfile (string-append upper-file extension)))
      (write-to-aibo *posture-comm* 
		     (string-append (exact->binary num) outfile)))))


(define write-sound
  (lambda (file)
    (let* ((upper-file (string-downcase file))
	   (extension (if (string-match ".wav" file) "" ".wav"))
	   (outfile (string-append upper-file extension)))
      ;(display outfile)
      (write-to-aibo *sound-comm* outfile))))

;; Procedures to execture specific .pos files.
(define stand
  (lambda () 
    (write-posture 700 "stand.pos")))

(define sit
  (lambda ()
    (write-posture 700 "situp.pos")))

(define pounce
  (lambda ()
    (write-posture 700 "pounce.pos")))

(define lie-down
  (lambda ()
    (write-posture 700 "liedown.pos")))


;; Procedures to activate or deactivate all of the AIBOs leds.
(define light-all
  (lambda ()
    (write-to-aibo *led-comm* (apply inexact->binary (map (lambda (x) 1.0) (iota 27))))))

(define light-off
  (lambda ()
    (write-to-aibo *led-comm* (apply inexact->binary (map (lambda (x) 0.0) (iota 27))))))

;; Initialize comm objects
(define *output-comm* (make-aibo-comm *dog-addr* *output-port* #f))
(define *posture-comm* (make-aibo-comm  *dog-addr* *posture-port* #f))
(define *walk-comm* (make-aibo-comm *dog-addr* *walk-port* #t))
(define *ear-comm* (make-aibo-comm *dog-addr* *ear-port* #t))
(define *joint-comm* (make-aibo-comm *dog-addr* *joint-port* #t))
(define *led-comm* (make-aibo-comm *dog-addr* *led-port* #f))
(define *sound-comm* (make-aibo-comm *dog-addr* *sound-port* #f))
;(define *lock-output-comm* (make-aibo-comm *dog-addr* *lock-output-port* #f))



(define write-outputs
  (output-maker *output-comm*))

;(define lock-outputs
;  (output-maker *lock-output-comm*))





;; Some high level procedures, must test these.
(define look-left
  (lambda () (write-outputs (list head-pan) (list 1))))

(define look-right
  (lambda () (write-outputs (list head-pan) (list -1))))

(define look-center
  (lambda () (write-outputs (list head-pan) (list 0))))

(define head-up
  (lambda () (write-outputs (list head-tilt) (list 0))))

(define head-down
  (lambda () (write-outputs (list head-tilt) (list -1))))

(define nod-up
  (lambda () (write-outputs (list head-nod) (list 1))))

(define nod-center
  (lambda () (write-outputs (list head-nod) (list 0.3))))

(define nod-down
  (lambda () (write-outputs (list head-nod) (list -1))))

(define mouth-open
  (lambda () (write-outputs (list mouth) (list -1))))

(define mouth-close
  (lambda () (write-outputs (list mouth) (list 0))))

(define tail-back
  (lambda () (write-outputs (list tail-tilt) (list 0))))

(define tail-front 
  (lambda () (write-outputs (list tail-tilt) (list 1))))

(define tail-left
  (lambda () (write-outputs (list tail-pan) (list 1))))

(define tail-right
  (lambda () (write-outputs (list tail-pan) (list -1))))

(define tail-center
  (lambda () (write-outputs (list tail-pan) (list 0))))

(define left-ear-in
  (lambda () (write-outputs (list ear-left) (list 0))))

(define left-ear-out
  (lambda () (write-outputs (list ear-left) (list 1))))

(define right-ear-in
  (lambda () (write-outputs (list ear-right) (list 0))))

(define right-ear-out
  (lambda () (write-outputs (list ear-right) (list 1))))


;; Led Procedures

;; Sets the LED value of the ear lights as an RGB value each component
;; from 0.0-1.0.
(define ear-led
  (lambda (r g b) (write-outputs (list led-mode-r led-mode-g led-mode-b)
				 (list r g b))))

(define head-top-led
  (lambda (x) (write-outputs (list led-head-color) (list x))))


(define led-a-mode
  (lambda () (write-output led-ab-mode 0.0)))

(define led-b-mode
  (lambda () (write-output led-ab-mode 1.0)))

(define led-back-color
  (lambda (front middle rear) 
    ;; For some reason write-outputs had trouble doing this
    (write-output led-back-front-color front)
    (write-output led-back-middle-color middle)
    (write-output led-back-rear-color rear)))

(define led-back-white
  (lambda (front middle rear)
    ;; For some reason write-outputs had trouble doing this
    (write-output led-back-front-white front)
    (write-output led-back-middle-white middle)
    (write-output led-back-rear-white rear)))



;; Sound Procedures....
(define bark-three
  (lambda () (write-sound "3barks")))

(define bark-high
  (lambda () (write-sound "barkhigh")))

(define bark
  (lambda () (write-sound "barkmed")))

(define bark-low
  (lambda () (write-sound "barklow")))

(define bark-real
  (lambda () (write-sound "barkreal")))

(define bark-yap
  (lambda () (write-sound "yap")))

(define bark-little
  (lambda () (write-sound "cutey")))

(define whimper
  (lambda () (write-sound "whimper")))

(define sniff
  (lambda () (write-sound "sniff")))

(define growl
  (lambda () (write-sound "growl")))

(define growl-long
  (lambda () (write-sound "growl2")))

(define roar
  (lambda () (write-sound "roar")))

(define meow
  (lambda () (write-sound "mew")))

(define cat-cry 
  (lambda () (write-sound "catcry")))

(define cat-yowl
  (lambda () (write-sound "catyowl")))

(define donkey
  (lambda () (write-sound "donkey")))

(define reset-dog
  (lambda ()
     (look-center)
     (nod-center)
     (tail-center)
     (mouth-close)
     (usleep 10)
     (pounce)
     (light-off)))



(if *read-world-state*
    (begin
      (define *world-state-comm* (make-aibo-comm *dog-addr* *world-state-port* #t))
      (define world-state-format
	'((1 . 1) (1 . 1) (1.0 . 54) (1.0 . 18) (1 .  1) (1.0 . 11) (1 . 1) (1.0 . 10) (1.0 . 18)))
      
      (define (world-state-reader)
	(let* ((raw (read-from-aibo *world-state-comm* 460)))
	  (set! *the-world-state* (binary->vector world-state-format (cdr raw))))
	(usleep 100)
	(world-state-reader))
      
      (make-thread world-state-reader)
      ))

