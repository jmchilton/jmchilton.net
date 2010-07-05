;;; SUPER TIC-TAC-TOE for STk by John Chilton and Tim Meyer 
;;; Requires the file gdraw.stk created by Dr. Dan Boley - 
;;; gdraw.stk can be found at: 
;;; http://www-users.itlabs.umn.edu/classes/Fall-2003/csci1901/files/gdraw.stk

;;; E-mail comments to John at chil0060@umn.edu

;;; Last modified 10:15 3-30-2004

;; Starting Super Tic-Tac-Toe -
;; 
;; Normal human vs. human super tic-tac-toe will start when this file is loaded.
;; This can be prevented by commenting out the last line of this file.
;; The start! procedure can be used to start a game, calling start! without
;; arguements will start a human vs. human tic-tac-toe game. start! can also take in
;; two optional arguements, the first corresponding to the X player and the second 
;; corresponding to the O player. To indicate a human player pass start! the symbol 
;; 'human. Just pass start! the name of an AI player procedure to setup an AI player.
;; For instance (start! random-ai 'human), will start a game with the random-ai procedure
;; (defined below) as X and a human player as O.

;; Relevent Data Structures - 
;;
;; There are two data structures that AI procedures will need to care about.
;; Big-board data structures are headed lists containing 9 little board 
;; data structures. Little board data structures are also headed lists with
;; containing 9 values, either 'x, 'o, (). Here 'x (or 'o) means that an X 
;; (or O) has been placed in the corresponding position, and () means the 
;; corresponding square is free. Big-board data structures are headed with 
;; symbol 'big, and little-board data structures are headed with the symbol
;; 'little

;; AI procedure requirements - 
;;
;; AI's must take in two paramters, the first of these
;; must be a big-board data structure (described above) ,
;; and the second of these is a variable indicating who
;; the AI is choosing for, this variable will be either 'x
;; or 'o, corresponding to player X or player O respectively. 
;;
;; The AI should return the two moves it intends to preform as
;; its turn. These should be in the form of a flat list, with the
;; first element corresponding to the first move and the second 
;; corresponding to the second move. Each of these moves should be
;; expressed as the pair (cons) of integers ranging in value from 1 to 9.
;; The first of these numbers, the car, should be the index of the little
;; board to place the piece into, and the second, the cdr, should be which 
;; the index of the square in the little board to move to. 
;;
;; Indexing of both little and big boards should be from 1 to 9, corresponding
;; to the position in the corresponding list of the target value.
;;
;; Indexes correspond to tic-tac-toe squares as follows:
;;
;;  1 |  2  |  3
;; -------------
;;  4 |  5  |  6
;; -------------
;;  7 |  8  |  9 
;;
;; (So the top left square has index 1, the center square on the top row has
;; has index 2, and so on.)
;;
;; The valid moves corresponding to the 81 big board positions are as follows,
;; where (x . y) respresents (cons x y):
;; (1 . 1) (1 . 2) (1 . 3) || (2 . 1) (2 . 2) (2 . 3) || (3 . 1) (3 . 2) (3 . 3)
;; (1 . 4) (1 . 5) (1 . 6) || (2 . 4) (2 . 5) (2 . 6) || (3 . 4) (3 . 5) (3 . 6)
;; (1 . 7) (1 . 8) (1 . 9) || (2 . 7) (2 . 8) (2 . 9) || (3 . 7) (3 . 8) (3 . 9)
;; =============================================================================
;; (4 . 1) (4 . 2) (4 . 3) || (5 . 1) (5 . 2) (5 . 3) || (6 . 1) (6 . 2) (6 . 3)
;; (4 . 4) (4 . 5) (4 . 6) || (5 . 4) (5 . 5) (5 . 6) || (6 . 4) (6 . 5) (6 . 6)
;; (4 . 7) (4 . 8) (4 . 9) || (5 . 7) (5 . 8) (5 . 9) || (6 . 7) (6 . 8) (6 . 9)
;; =============================================================================
;; (7 . 1) (7 . 2) (7 . 3) || (8 . 1) (8 . 2) (8 . 3) || (9 . 1) (9 . 2) (9 . 3)
;; (7 . 4) (7 . 5) (7 . 6) || (8 . 4) (8 . 5) (8 . 6) || (9 . 4) (9 . 5) (9 . 6)
;; (7 . 7) (7 . 8) (7 . 9) || (8 . 7) (8 . 8) (8 . 9) || (9 . 7) (9 . 8) (9 . 9)
;;
;; So a valid return of an ai, corresponding to the taking of the center square of
;; the center board, and the center square of the top right cornor, would be the 
;; structure (list (cons 5 5) (cons 3 5)) or anything equivelent, like
;; (cons (cons 5 5) (cons (cons 3 5) '()))
;;
;; Note: If there is only one move left to make, or if for some reason an AI wants 
;; to just make one move, make sure that what is returned is a two element list, and
;; that at least one of these elements is the intended move, the other should just
;; be ().
;;
;; Move Advance Mode -
;; 
;; If move advance mode is set to automatic then computer players will be called 
;; automatically when it is there turn, if advance mode is set to manual then computer
;; moves will not be made until the next move button is clicked. To change between
;; these moves just click on the "Click here to toggle" button on the user interface.
;; How quickly the automatic advance proceeds can be adjusted by changing the global
;; variable interval. interval is the number of milliseconds between computer moves.
;; By default interval is 0, and the computer vs. computer games happen all at once.
;; Changing interval to around 10 will run very fast games. Changing interval to around
;; 750-1500 will make the games run at speed that make them easy to follow. interval
;; can be changed in the same way as any other global, for instance entering 
;; (define interval 100) into the STk prompt after this file has been loaded 
;; will change interval to 100.


;; Loading gdraw.stk
(load "gdraw.stk")

;;;;; Internal Board Parameters

(define X 'x)
(define O 'o)
(define null-value ())   ;; Indicates no move has benn made

;;;;;; Internal Board Procedures written by John Chilton

(define (new-little-board)  ;; Creates a new little board, with all squares as null values
  (list 'little null-value null-value null-value null-value null-value null-value null-value null-value null-value))

(define (new-big-board)  ;; Creates a new big board, with all unfilled little boards
  (list 'big 
	(new-little-board) (new-little-board) (new-little-board)
	(new-little-board) (new-little-board) (new-little-board)
	(new-little-board) (new-little-board) (new-little-board)))


(define (make-deep-copy big-board)   ;; Deep clones a board, allowing mutations of new board not to affect old one.
  (define (list-copy list)
    (if (null? list)
	()
	(cons (car list) (list-copy (cdr list)))))
  
  (define (deep-copy list)
    (if (null? list)
	()
	(cons (list-copy (car list)) (deep-copy (cdr list)))))
  
  (cons 'big (deep-copy (cdr big-board))))





(define (get-little-board big-board x) ;Extract a little board from a big board
  (list-ref big-board x))

(define (get-who-little little-board position) ; Who is in what square of what little-board
  (list-ref little-board position))

(define (get-who-big big-board big-pos little-pos)  ;; Access individual squares from a big-board
  (get-who-little (get-little-board big-board big-pos) little-pos))

(define (set-position! list x element)  ;; Change the value at a square of a little board
  (if (= x 0)
      (set-car! list element)
      (set-position! (cdr list) (- x 1) element)))

(define (set-who-big! big-board big-pos little-pos who) ;; Change value of individual squares from big board
  (if (or (< big-pos 1) (< little-pos 1) (> big-pos 9) (> little-pos 9))
      (error "Invalid position sent to set-who-big")
      (set-position! (get-little-board big-board big-pos) little-pos who)))



(define (won-little-board? little-board who)  ;;; Checks if who has won little-board
  (define (check? little-board who start increment)
    (and (eq? who (get-who-little little-board start))
	 (eq? who (get-who-little little-board (+ start increment)))
	 (eq? who (get-who-little little-board (+ start increment increment)))))    
  (or (check? little-board who 1 1)
      (check? little-board who 1 4)
      (check? little-board who 1 3)
      (check? little-board who 2 3)
      (check? little-board who 3 3)
      (check? little-board who 3 2)
      (check? little-board who 4 1)
      (check? little-board who 7 1)))


(define (reduce-big big-board)      ;;; Converts a big-board into a little-board with each square of the little board
  (define (get-symbol little-board) ;;; beinging either an X or an O value if someone has won the corresponding little board
    (cond ((won-little-board? little-board X) 
	   X)
	  ((won-little-board? little-board O)
	   O)
	  (else null-value)))

  (define (iter position)
    (cond ((= position 10)
	   ())
	  (else 
	   (cons (get-symbol 
		  (get-little-board big-board position))
		 (iter (+ position 1))))))

  (cons 'little (iter 1)))

(define (won-big-board? big-board who)   ;;; Tests if player who has won big-board, via the reduce-big procedure
  (won-little-board? (reduce-big big-board) who))

(define (no-winner? little-board) ;;; Checks if little-board hasn't been won yet  
  (and (not (won-little-board? little-board X)) (not (won-little-board? little-board O))))

(define (cats-game-little? little-board) ;;; Checks if there is a cats game on little-board
  (define (iter pos)
    (if (> pos 9)
	#t
	(if (eq? (get-who-little little-board pos) null-value)
	    #f
	    (iter (+ pos 1)))))
  
  (iter 1))

(define (cats-game-big? big-board)    ;;; Checks if there is a cats game on big-board
  (define (iter pos)
    (if (> pos 9)
	#t
	(begin
	  (let ((current-little (get-little-board big-board pos)))
	    (if (> pos 9)
		#t
		(if (or (cats-game-little? current-little) 
			(won-little-board? current-little X)
			(won-little-board? current-little O))
		    (iter (+ pos 1))
		    #f))))))

  (iter 1))

;;; Procedures for text-based display of board state written by John Chilton
;;; These may be useful for debugging purpose, or for testing your AI with MIT scheme

(define (display-who who)
  (cond ((eq? who X) (display "X "))
	((eq? who O) (display "O "))
	(else (display "  "))))

(define (display-who-padded who)
  (display-who who)
  (display " "))

(define (display-three little-board x) ;x from { 0, 1, 2  }  Doesn't follow index standard
  (display-who (get-who-little little-board (+ (* 3 x) 1)))
  (display-who (get-who-little little-board (+ (* 3 x) 2)))
  (display-who (get-who-little little-board (+ (* 3 x) 3))))

(define (display-big-board-row big-board x) ;0-8
  (define (int/ x y)  (quotient x y))
  (display-three (get-little-board big-board (+ (* 3 (int/ x 3)) 1)) (remainder x 3))   (display "  ")
  (display-three (get-little-board big-board (+ (* 3 (int/ x 3)) 2)) (remainder x 3))   (display "  ")
  (display-three (get-little-board big-board (+ (* 3 (int/ x 3)) 3)) (remainder x 3)))


(define (display-big-board big-board)
  (define (iter x)
    (if  (> x 8)
	 (newline)
	 (begin 
	   (display-big-board-row big-board x)
	   (newline)
	   (iter (+ x 1)))))
  (iter 0))


;;; Random AI by John Chilton

;;; Random AI support code

;;; -----------------------------------------------------------------
;;; Random numbers
;;; from http://sicp.ai.mit.edu/Fall-2000/psets/project1/index.html
;;; -----------------------------------------------------------------

;; Pick a random number between 2 and n-1
(define (choose-random n)
  (+ 2 (random (- n 2))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Random  [for STK only]
;;;;    This version of random is constructed over the C one. It can return
;;;;    bignum numbers. Idea is due to Nobuyuki Hikichi <hikichi@sra.co.jp>
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define random 
  (let ((C-random random)
        (max-rand #x7fffffff)) ; Probably more on 64 bits machines
    (letrec ((rand (lambda (n)
                     (cond 
                      ((zero? n)           0)
                      ((< n max-rand) (C-random n))
                      (else       (+ (* (rand (quotient n max-rand)) max-rand)
                                     (rand (remainder n max-rand))))))))
      (lambda (n)
        (if (zero? n)
            (error "random: bad number: 0")
            (rand n))))))

;;; End Random AI outside support code

(define (random-AI board who-am-i)
 
  (define (mod10 y)  ;;; Returns y mod 10, but won't return 0, returns 1 instead
    (let ((temp (remainder y 10)))
      (if (= temp 0)
	  1
	  temp)))
 
  (define (open? little-board)
    (define (free-square? x)
      (if (> x 9)
	  #f
	  (if (eq? (get-who-little little-board x) null-value)
	      #t
	      (free-square? (+ x 1)))))
    (and (no-winner? little-board) (free-square? 1)))
  
  (define (find-open-little-board board x)   ;;; x is random starting point
    (define (iter y)
      (if (open? (get-little-board board (mod10 y)))
	  (mod10 y)
	  (if (= x (mod10 (+ y 1)))
	      ()
	      (iter (+ 1 y)))))

    (iter x))
  
  (define (get-random-square little-board) ;;; x is random starting point
    (define (iter y)           
      (if (eq? (get-who-little little-board y) null-value)
	  y
	  (iter (mod10 (+ y 1)))))
    (iter (1- (choose-random 11)))) 
  
  (define (get-random-pair board)
    (let ((board-num (find-open-little-board board  (1- (choose-random 11)))))
      (if (null? board-num)
	  ()
	  (cons board-num (get-random-square (get-little-board board board-num))))))
  
  (let ((first-pair (get-random-pair board)))
    (cond ((null? first-pair) (list () ()))
	  (else (set-who-big! board (car first-pair) (cdr first-pair) who-am-i)
		(list first-pair (get-random-pair board))))))


;;;; TIC-TAC-TOE DRIVER CODE written by John Chilton


(define (board-to-graphics x)    ;;; Used to translate coordinates between board representation and graphical one
  (cons 
   (+ (* 3 (remainder (- (car x) 1) 3)) (remainder (- (cdr x) 1) 3))
   (+ (* 3 (quotient (- (car x) 1) 3)) (quotient (- (cdr x) 1) 3))))

  
(define (reset!)
  (display "Reseting game.")
  (driver 'reset))

(define interval 0)   ;;; msecs between autmatic turns                                                                                        
(define (start! . options)  
  (set! driver (make-new-driver) )
  (display "Starting new game.")
  (driver 'start options))

(define (make-new-driver)   ;;; Returns a game-driver procedure

  (let (     ;;; BOARD STATE VARIABLES
	(playerx 'human)
	(playero 'human)
	(board (new-big-board))  ;;; The main board, internal representation                                                                   
	(active #f)   ;;; Is board active                                                                                                      
	(current-player X)   ;;; Whose turn it is                                                                                              
	(current-turn 0)    ;;; Number of pieces they have placed this turn                                                                    
	(moves-made 0)    ;;; Number of moves made this game                  
	(next-move-mode 'auto)	
	)

    
    ;;;;;GRAPHICAL BOARD VARIABLES
    
    (define (average x y) (quotient (+ x y) 2))
    
    (define left 10)
    (define top 10)
    (define sml-sqr-width 50)
    (define sml-sqr-height 50)
    (define spacer 15)
    (define dimensions 3)
    (define big-sqr-width (+ spacer spacer (* sml-sqr-width dimensions)))
    (define big-sqr-height (+ spacer spacer (* sml-sqr-height dimensions)))
    (define big-line-width 4)
    (define big-piece-width 3)
    (define total-width (* big-sqr-width dimensions))
    (define total-height (* big-sqr-height dimensions))
    
    
    (define reset-button-x (+ left (* 1 (/ total-width 2))))
    (define reset-button-y (+ top total-height 20))
    
    (define next-button-x (+ left (/ total-width 6)))
    (define next-button-y (+ top total-height 20))
    
    (define mode-swap-button-x (* 4 (+ left (/ total-width 5))))
    (define mode-swap-button-y (+ top total-height 20))
    
    
    (define status-x (+ left (* 2 (/ total-width 4))))
    (define status-y (+ top total-height 80))

    (define background-color 'black)
    (define button-color 'white)
    (define mouse-over-color 'red)
    (define line-color 'grey)
    (define status-color 'green)
    (define font-size '140)
    (define x-color 'green)
    (define o-color 'blue)
    
    (define status-list  (list
			  "It is player X's first turn."
			  "It is player X's second turn."
			  "It is player O's first turn."
			  "It is player O's second turn."))
    
    (define status-text ())
    (define next-text ())
    
    ;;;;; GRAPHICAL BOARD PROCEDURES written by Timothy Meyer and John Chilton
    
    (define (display-status! . msg)
      (if (null? msg)
	  (if (< (remainder moves-made 4) 2)
	      (begin 
		(set-text! status-text (list-ref status-list (remainder moves-made 4)))
		(set-color! status-text x-color))
	      (begin
		(set-text! status-text (list-ref status-list (remainder moves-made 4)))
		(set-color! status-text o-color)))
	  (begin 
	    (set-text! status-text (car msg))
	    (if (not (null? (cdr msg)))
		(set-color! status-text (cadr msg))))))
    
    (define (draw-move-mode!) (set-text! next-text (get-move-mode-string)))
    
    (define (draw-board)
      ;; Draws canvas
      (set-width! 0 (+ top top 120 total-height) (+ left left total-width))
      (set-color! (draw-rectangle 0 0 (+ left left total-width) (+ top top 120 total-height)) background-color)
      
      ;; Draws reset button
      (define reset-button (draw-text "Reset Board" reset-button-x reset-button-y))
      (set-color! reset-button button-color)
      (set-over-binding! reset-button (lambda () (set-color! reset-button mouse-over-color)) (lambda ()  (set-color! reset-button button-color)))
      (set-binding! reset-button (lambda () (driver 'reset)))
      
      ;; Draws next button
      (define next-button (draw-text "Advance turn" next-button-x next-button-y)) 
      (set-color! next-button button-color)
      (set-binding! next-button (lambda () (driver 'go)))
      (set-over-binding! next-button (lambda () (set-color! next-button mouse-over-color)) (lambda ()  (set-color! next-button button-color)))
      
      ;; Draws the move mode button
     
      (set! next-text (draw-text (get-move-mode-string) mode-swap-button-x mode-swap-button-y))
      (set-color! next-text button-color)
      (set-binding! next-text (lambda () (swap-move-mode!) (draw-move-mode!)))
      (set-over-binding! next-text (lambda () (set-color! next-text mouse-over-color)) (lambda () (set-color! next-text button-color)))
  
      ;;Draws the status text label
      (set! status-text (draw-text "" status-x status-y))
      (set-color! status-text status-color)
      (display-status!)
      (raise! status-text)
      
      (define (draw-big-board current)
	(if (< current dimensions)
	    (begin
	      (define x (draw-line 
			 left 
			 (+ top (* current big-sqr-height)) 
			 (+ left total-width) 
			 (+ top (* current big-sqr-height))))
	      (set-width! x big-line-width)
	      (set-color! x line-color)
	      (define x (draw-line 
			 (+ left (* current big-sqr-width)) 
			 top 
			 (+ left (* current big-sqr-width)) 
			 (+ top total-height)))
	      (set-width! x big-line-width)
	      (set-color! x line-color)
	      
	      (draw-big-board (+ 1 current)))))
      
      (draw-big-board 1)
      
      (define (iter i)
	(define (iter2 j)
	  (if (< j dimensions)
	      (begin
		(define (iter3 current)
		  (if (< current dimensions)
		      (begin
			(set-color! (draw-line
				     (+ left spacer (* big-sqr-width i))
				     (+ top spacer (* big-sqr-height j) (* current sml-sqr-height))
				     (+ left spacer (* big-sqr-width i) (* sml-sqr-width dimensions))
				     (+ top spacer (* big-sqr-height j) (* current sml-sqr-height))) 
				    line-color)
			(set-color! (draw-line
				     (+ left spacer (* current sml-sqr-width) (* big-sqr-width i))
				     (+ top spacer (* big-sqr-height j))
				     (+ left spacer (* current sml-sqr-width) (* big-sqr-width i))
				     (+ top spacer (* big-sqr-height j) (* dimensions sml-sqr-height))) 
				    line-color)
			(iter3 (+ 1 current)))))
		(iter3 1)
		(iter2 (+ j 1)))))
	
	(if (< i dimensions)
	    (begin
	      (iter2 0)
	      (iter (+ i 1)))))
      
      (iter 0))
    
    
    (define (place-piece i j x1 y1 piece) ; x's y's start at 0 
      (if (equal? piece X)
	  (begin               ;;; Draws an X
	    (set-color! (draw-line
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width x1) 2)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height y1) 2)
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width (+ 1 x1)) -2)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height (+ 1 y1)) -2)
			 ) 
			x-color)
	    (set-color! (draw-line
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width x1) 2)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height (+ 1 y1)) -2)
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width (+ 1 x1)) -2)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height y1) 2)
			 )
			x-color))
	  (begin              ;;; Draws an O
	    (set-color! (draw-oval
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width x1) 2)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height y1) 2)
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width (+ 1 x1)) -2)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height (+ 1 y1)) -2)
			 ) 
			o-color)
	    (set-color! (draw-oval
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width x1) 4)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height y1) 4)
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width (+ 1 x1)) -4)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height (+ 1 y1)) -4)
			 ) 
			background-color))))
    
    (define (win-square x1 y1 piece) ; x and y start at 0
      (set-color! (draw-rectangle
		   (+ left spacer (* big-sqr-width x1))
		   (+ top spacer (* big-sqr-height y1))
		   (+ left spacer (* big-sqr-width x1) (* dimensions sml-sqr-width))
		   (+ top spacer (* big-sqr-height y1) (* dimensions sml-sqr-height)))
		  background-color)
      (if (equal? piece X)
	  (begin
	    (define x (draw-line 
		       (+ left spacer (* big-sqr-width x1))
		       (+ top spacer (* big-sqr-height y1))
		       (+ left spacer (* big-sqr-width x1) (* dimensions sml-sqr-width))
		       (+ top spacer (* big-sqr-height y1) (* dimensions sml-sqr-height))))
	    (set-width! x big-line-width)
	    (set-color! x x-color)
	    (define x (draw-line 
		       (+ left spacer (* big-sqr-width x1))
		       (+ top spacer (* big-sqr-height y1) (* dimensions sml-sqr-height))
		       (+ left spacer (* big-sqr-width x1) (* dimensions sml-sqr-width))
		       (+ top spacer (* big-sqr-height y1))))
	    (set-width! x big-line-width)
	    (set-color! x x-color))
	  (begin
	    (define x (fill-oval
		       (+ left spacer (* big-sqr-width x1))
		       (+ top spacer (* big-sqr-height y1))
		       (+ left spacer (* big-sqr-width x1) (* dimensions sml-sqr-width))
		       (+ top spacer (* big-sqr-height y1) (* dimensions sml-sqr-height))))
	    (set-width! x big-line-width)
	    (set-color! x o-color)
	    (define x (fill-oval
		       (+ left spacer (* big-sqr-width x1) big-line-width 2)
		       (+ top spacer (* big-sqr-height y1) big-line-width 2)
		       (- (+ left spacer (* big-sqr-width x1) (* dimensions sml-sqr-width) -2) big-line-width)
		       (- (+ top spacer (* big-sqr-height y1) (* dimensions sml-sqr-height) -2) big-line-width)))
	    (set-color! x background-color))))
    
    
    (define (get-square x y) ; returns ((big-x, big-y), (small-x, small-y))
      (define x1 (quotient (- x left) big-sqr-width))
      (define y1 (quotient (- y top) big-sqr-height))
      (define x2 (quotient (- x (+ (* x1 big-sqr-width) spacer left)  ) sml-sqr-width))
      (define y2 (quotient (- y (+ (* y1 big-sqr-height) spacer top)) sml-sqr-height))
      (if (or (< x1 0) (< x2 0) (< y1 0) (< y2 0) (> x1 (- dimensions 1)) (> x2 (- dimensions 1)) (> y1 (- dimensions 1)) (> y2 (- dimensions 1)))
	  (cons (cons -1 -1) (cons -1 -1)) 
	  (cons (cons x1 y1) (cons x2 y2))))
    
    
    ;;;;; BOARD STATE PROCEDURES
    
    (define (reset-game!)  ;;; Resets the game state                                                                                                                                                  
      (clear-graphics!)
      (set! board (new-big-board))
      (reset-current-player!)
      (set! active #t)
      (draw-board)
      (if (and (not (eq? (get-current-player) 'human)) (eq? next-move-mode 'auto))
	  (driver 'go)))
    
    (define (start-game!  players)  ;;;; Procedures to start the game                                                                          
      (set! board (new-big-board))
      (reset-current-player!)
      (set! active #t)
      (clear-graphics!)
      (draw-board)
      (cond ((null? players)  (set! playerx 'human) (set! playero 'human))
	    ((null? (cdr players)) (set! playerx (car players)) (set! playero 'human))
	    (else (set! playerx (car players)) (set! playero (cadr players))))
      
      (if (and (not (eq? (get-current-player) 'human)) (eq? next-move-mode 'auto))
	  (driver 'go)))

    (define (valid-move? move) ;Checks if a move is valid-> move of form ( big-pos . small-pos )                                                  
      (and (pair? move)
	   (integer? (car move))
	   (integer? (cdr move))
	   (>= (car move) 1)
	   (>= (cdr move) 1)
	   (<= (car move) 9)
	   (<= (cdr move) 9)
	   (no-winner? (get-little-board board (car move)))
	   (eq? (get-who-little (get-little-board board (car move)) (cdr move)) null-value)))
    
    
    (define (valid-move-list? move-list) ; Checks to see if move-list generated by ai is of correct form                                          
      (and (pair? move-list)
	   (pair? (cdr move-list))))
    
    (define (swap-move-mode!) (set! next-move-mode (if (eq? next-move-mode 'auto) 'manual 'auto)))
    
    (define (get-move-mode-string)
      (if (eq? next-move-mode 'auto)
	  "Current move advance mode:\nAutomatic\nClick here to toggle"
	  "Current move advance mode:\n Manual\nClick here to toggle"))
    
    (define (get-current-player)  ;;; Returns either playerx or playero, the procedures.                  
      (if (eq? current-player X)
	  playerx
	  playero))
    
    (define (reset-current-player!)  ;;; Resets parameters dealing with whose turn it is and number of                                                                                                            
      (set! current-turn 0)          ;;; turns made.                                                               
      (set! moves-made 0)
      (set! current-player X))
    
    ;;; Updates current-player and number of turns, after human move                                                                                                                                                              
    (define (swap-current-player!)
    (if (= current-turn 0)
        (set! current-turn 1)
        (if(eq? current-player X)
           (begin
             (set! current-player O)
             (set! current-turn 0))
           (begin
             (set! current-player X)
             (set! current-turn 0)))))
  
    
    ;;;;; Updates current player, moves-made, and status bar after human move                                                                  
    (define (update-human-move!)
      (set! moves-made (+ moves-made 1))
      (swap-current-player!)
      (display-status!))
    
    ;;;;;; Updates current player, moves-made, and status bar after computer move                        
    (define (update-computer-move!)
      (set! moves-made (+ moves-made 2))
      (if (eq? current-player X)
	  (set! current-player O)
	  (set! current-player X))
      (set! current-turn 0)
      (display-status!))
    
    ;;;;;; Handles doing of actual move, must be sent a valid one, this            
    ;;;;;; draws the piece on the board and updates the internal board.            
    

    (define (do-valid-move! move who)
      (define coord (board-to-graphics move))
      (place-piece (remainder (- ( car move) 1) 3)
		   (quotient (- (car move) 1) 3)
		   (remainder (- (cdr move) 1) 3)
               (quotient (- (cdr move) 1) 3) who)
      
      (set-who-big! board
		    (car move)
		    (cdr move)
		    who))
    
    ;;;;; Checks the global board to see if who has one little-board at board-pos                                                      
    (define (check-and-handle-win-little board-pos who)
      (if (won-little-board? (get-little-board board board-pos) who)
	  (win-square (remainder (- board-pos 1) 3)
		      (quotient (- board-pos 1) 3)
		      who)))

    ;;;;; Checks the global board to see if who has won                                      
    (define (check-and-handle-win-big who)
      (if (won-big-board? board who) (handle-win!)))
     
    ;;;;; Checks the global board for cats game                                                                                                                                                
    (define (check-and-handle-cats-big!)
      (cond ((and active (cats-game-big? board))
         (set! active #f)
         (display-status! "Cat's game!" 'red))))
    
    (define (handle-win!)
      (if (eq? current-player X)
	  (display-status!  "Player X wins!")
      (display-status!  "Player O wins!"))
      (set! active #f))
    
    
    
    (lambda (. options)
					;driver code here
      (cond ((null? options)
					; Human move
	     (define clicked-square (get-square (car (get-mouse-coords)) (cadr (get-mouse-coords))))
	     (define board-big (+ (caar clicked-square) 1 (* dimensions (cdar clicked-square))))
	     (define board-small (+ (cadr clicked-square) 1 (* dimensions (cddr clicked-square))))
	     (cond ((and (eq?  (get-current-player) 'human)  ;;; Check to make sure it is a human's turn                                                 
			 (> (caar clicked-square) -1)                                     ;;; Valid square click?                                        
			 (eq? (get-who-big board board-big board-small) null-value)
			 (no-winner? (get-little-board board board-big))
			 active)                                                  ;;; Board open                                                         
                                                               ;;;; HUMAN PLAYER MADE VALID MOVE                                              
		    (place-piece (caar clicked-square) (cdar clicked-square) (cadr clicked-square) (cddr clicked-square) current-player)
		    (do-valid-move! (cons board-big board-small) current-player)
		    (check-and-handle-win-little board-big current-player)
		    (check-and-handle-win-big current-player)
		    (check-and-handle-cats-big!)
		    (if active (update-human-move!))
		    (if (and (not (eq? (get-current-player) 'human)) (eq? next-move-mode 'auto))
			(driver 'go)))))	     
         
	    ((eq? (car options) 'go)
                                        ; Computer player needs to make move.
	     
	     (cond ((and   (not (eq? (get-current-player) 'human))
			   active)                     ;;; Computer move
		    (let ((moves ((if (eq? current-player X) playerx playero) (make-deep-copy board) (if (eq? current-player X) X O))))
		      (cond ((not (valid-move-list? moves))   )  ;; Malformed move-list                                                                  
			    ((and (valid-move? (car moves)) (valid-move? (cadr moves)))
			     (do-valid-move! (car moves) current-player)
			     (check-and-handle-win-little (caar moves) current-player)
			     (check-and-handle-win-big current-player)
			     (check-and-handle-cats-big!)
			     (cond ((valid-move? (cadr moves))
				    (do-valid-move! (cadr moves) current-player)
				    (check-and-handle-win-little (caadr moves) current-player)
				    (check-and-handle-win-big current-player)
				    (check-and-handle-cats-big!)
				    )))
			    ((valid-move? (car moves))
			     (do-valid-move! (car moves) current-player)
			     (check-and-handle-win-little (caar moves) current-player)
			     (check-and-handle-win-big current-player)
		       
			     (check-and-handle-cats-big!))
			    ((valid-move? (cadr moves))
			     (do-valid-move! (cadr moves) current-player)
			     (check-and-handle-win-little (car (cadr moves)) current-player)
			     (check-and-handle-win-big current-player))))
		    
		    (cond (active
			   (update-computer-move!)
			   (if (or (eq? (get-current-player) 'human) (eq? next-move-mode 'manual))
			       (stall)
			       (after interval (lambda () (driver 'go)))))))))
	    ((eq? (car options) 'start)
					; Start up game  
	     (start-game! (cadr options))
	     )
	    ((eq? (car options) 'reset)
	     (reset-game!)
	     )
	    (else (display "Invalid call to driver"))))))


;(define driver (make-new-driver))



;;;; Start on load start human vs. human game
;(start!)



(define (make-new-tourney-driver)   ;;; Returns a game-driver procedure

  (let (     ;;; BOARD STATE VARIABLES
	(playerx 'human)
	(playero 'human)
	(board (new-big-board))  ;;; The main board, internal representation                                                                   
	(active #f)   ;;; Is board active                                                                                                      
	(current-player X)   ;;; Whose turn it is                                                                                              
	(current-turn 0)    ;;; Number of pieces they have placed this turn                                                                    
	(moves-made 0)    ;;; Number of moves made this game                  
	(next-move-mode 'auto)	
	)

    
    ;;;;;GRAPHICAL BOARD VARIABLES
    
    (define (average x y) (quotient (+ x y) 2))
    
    (define left 10)
    (define top 10)
    (define sml-sqr-width 50)
    (define sml-sqr-height 50)
    (define spacer 15)
    (define dimensions 3)
    (define big-sqr-width (+ spacer spacer (* sml-sqr-width dimensions)))
    (define big-sqr-height (+ spacer spacer (* sml-sqr-height dimensions)))
    (define big-line-width 4)
    (define big-piece-width 3)
    (define total-width (* big-sqr-width dimensions))
    (define total-height (* big-sqr-height dimensions))
    
    
    (define reset-button-x (+ left (* 1 (/ total-width 2))))
    (define reset-button-y (+ top total-height 20))
    
    (define next-button-x (+ left (/ total-width 6)))
    (define next-button-y (+ top total-height 20))
    
    (define mode-swap-button-x (* 4 (+ left (/ total-width 5))))
    (define mode-swap-button-y (+ top total-height 20))
    
    
    (define status-x (+ left (* 2 (/ total-width 4))))
    (define status-y (+ top total-height 80))

    (define background-color 'black)
    (define button-color 'white)
    (define mouse-over-color 'red)
    (define line-color 'grey)
    (define status-color 'green)
    (define font-size '140)
    (define x-color 'green)
    (define o-color 'blue)
    
    (define status-list  (list
			  "It is player X's first turn."
			  "It is player X's second turn."
			  "It is player O's first turn."
			  "It is player O's second turn."))
    
    (define status-text ())
    (define next-text ())
    
    ;;;;; GRAPHICAL BOARD PROCEDURES written by Timothy Meyer and John Chilton
    
    (define (display-status! . msg)
      (if (null? msg)
	  (if (< (remainder moves-made 4) 2)
	      (begin 
		(set-text! status-text (list-ref status-list (remainder moves-made 4)))
		(set-color! status-text x-color))
	      (begin
		(set-text! status-text (list-ref status-list (remainder moves-made 4)))
		(set-color! status-text o-color)))
	  (begin 
	    (set-text! status-text (car msg))
	    (if (not (null? (cdr msg)))
		(set-color! status-text (cadr msg))))))
    
    (define (draw-move-mode!) (set-text! next-text (get-move-mode-string)))
    
    (define (draw-board)
      ;; Draws canvas
      (set-width! 0 (+ top top 120 total-height) (+ left left total-width))
      (set-color! (draw-rectangle 0 0 (+ left left total-width) (+ top top 120 total-height)) background-color)
      
      ;; Draws reset button
      (define reset-button (draw-text "Reset Board" reset-button-x reset-button-y))
      (set-color! reset-button button-color)
      (set-over-binding! reset-button (lambda () (set-color! reset-button mouse-over-color)) (lambda ()  (set-color! reset-button button-color)))
      (set-binding! reset-button (lambda () (driver 'reset)))
      
      ;; Draws next button
      (define next-button (draw-text "Advance turn" next-button-x next-button-y)) 
      (set-color! next-button button-color)
      (set-binding! next-button (lambda () (driver 'go)))
      (set-over-binding! next-button (lambda () (set-color! next-button mouse-over-color)) (lambda ()  (set-color! next-button button-color)))
      
      ;; Draws the move mode button
     
      (set! next-text (draw-text (get-move-mode-string) mode-swap-button-x mode-swap-button-y))
      (set-color! next-text button-color)
      (set-binding! next-text (lambda () (swap-move-mode!) (draw-move-mode!)))
      (set-over-binding! next-text (lambda () (set-color! next-text mouse-over-color)) (lambda () (set-color! next-text button-color)))
  
      ;;Draws the status text label
      (set! status-text (draw-text "" status-x status-y))
      (set-color! status-text status-color)
      (display-status!)
      (raise! status-text)
      
      (define (draw-big-board current)
	(if (< current dimensions)
	    (begin
	      (define x (draw-line 
			 left 
			 (+ top (* current big-sqr-height)) 
			 (+ left total-width) 
			 (+ top (* current big-sqr-height))))
	      (set-width! x big-line-width)
	      (set-color! x line-color)
	      (define x (draw-line 
			 (+ left (* current big-sqr-width)) 
			 top 
			 (+ left (* current big-sqr-width)) 
			 (+ top total-height)))
	      (set-width! x big-line-width)
	      (set-color! x line-color)
	      
	      (draw-big-board (+ 1 current)))))
      
      (draw-big-board 1)
      
      (define (iter i)
	(define (iter2 j)
	  (if (< j dimensions)
	      (begin
		(define (iter3 current)
		  (if (< current dimensions)
		      (begin
			(set-color! (draw-line
				     (+ left spacer (* big-sqr-width i))
				     (+ top spacer (* big-sqr-height j) (* current sml-sqr-height))
				     (+ left spacer (* big-sqr-width i) (* sml-sqr-width dimensions))
				     (+ top spacer (* big-sqr-height j) (* current sml-sqr-height))) 
				    line-color)
			(set-color! (draw-line
				     (+ left spacer (* current sml-sqr-width) (* big-sqr-width i))
				     (+ top spacer (* big-sqr-height j))
				     (+ left spacer (* current sml-sqr-width) (* big-sqr-width i))
				     (+ top spacer (* big-sqr-height j) (* dimensions sml-sqr-height))) 
				    line-color)
			(iter3 (+ 1 current)))))
		(iter3 1)
		(iter2 (+ j 1)))))
	
	(if (< i dimensions)
	    (begin
	      (iter2 0)
	      (iter (+ i 1)))))
      
      (iter 0))
    
    
    (define (place-piece i j x1 y1 piece) ; x's y's start at 0 
      (if (equal? piece X)
	  (begin               ;;; Draws an X
	    (set-color! (draw-line
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width x1) 2)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height y1) 2)
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width (+ 1 x1)) -2)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height (+ 1 y1)) -2)
			 ) 
			x-color)
	    (set-color! (draw-line
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width x1) 2)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height (+ 1 y1)) -2)
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width (+ 1 x1)) -2)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height y1) 2)
			 )
			x-color))
	  (begin              ;;; Draws an O
	    (set-color! (draw-oval
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width x1) 2)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height y1) 2)
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width (+ 1 x1)) -2)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height (+ 1 y1)) -2)
			 ) 
			o-color)
	    (set-color! (draw-oval
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width x1) 4)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height y1) 4)
			 (+ left spacer (* big-sqr-width i) (* sml-sqr-width (+ 1 x1)) -4)
			 (+ top spacer (* big-sqr-height j) (* sml-sqr-height (+ 1 y1)) -4)
			 ) 
			background-color))))
    
    (define (win-square x1 y1 piece) ; x and y start at 0
      (set-color! (draw-rectangle
		   (+ left spacer (* big-sqr-width x1))
		   (+ top spacer (* big-sqr-height y1))
		   (+ left spacer (* big-sqr-width x1) (* dimensions sml-sqr-width))
		   (+ top spacer (* big-sqr-height y1) (* dimensions sml-sqr-height)))
		  background-color)
      (if (equal? piece X)
	  (begin
	    (define x (draw-line 
		       (+ left spacer (* big-sqr-width x1))
		       (+ top spacer (* big-sqr-height y1))
		       (+ left spacer (* big-sqr-width x1) (* dimensions sml-sqr-width))
		       (+ top spacer (* big-sqr-height y1) (* dimensions sml-sqr-height))))
	    (set-width! x big-line-width)
	    (set-color! x x-color)
	    (define x (draw-line 
		       (+ left spacer (* big-sqr-width x1))
		       (+ top spacer (* big-sqr-height y1) (* dimensions sml-sqr-height))
		       (+ left spacer (* big-sqr-width x1) (* dimensions sml-sqr-width))
		       (+ top spacer (* big-sqr-height y1))))
	    (set-width! x big-line-width)
	    (set-color! x x-color))
	  (begin
	    (define x (fill-oval
		       (+ left spacer (* big-sqr-width x1))
		       (+ top spacer (* big-sqr-height y1))
		       (+ left spacer (* big-sqr-width x1) (* dimensions sml-sqr-width))
		       (+ top spacer (* big-sqr-height y1) (* dimensions sml-sqr-height))))
	    (set-width! x big-line-width)
	    (set-color! x o-color)
	    (define x (fill-oval
		       (+ left spacer (* big-sqr-width x1) big-line-width 2)
		       (+ top spacer (* big-sqr-height y1) big-line-width 2)
		       (- (+ left spacer (* big-sqr-width x1) (* dimensions sml-sqr-width) -2) big-line-width)
		       (- (+ top spacer (* big-sqr-height y1) (* dimensions sml-sqr-height) -2) big-line-width)))
	    (set-color! x background-color))))
    
    
    (define (get-square x y) ; returns ((big-x, big-y), (small-x, small-y))
      (define x1 (quotient (- x left) big-sqr-width))
      (define y1 (quotient (- y top) big-sqr-height))
      (define x2 (quotient (- x (+ (* x1 big-sqr-width) spacer left)  ) sml-sqr-width))
      (define y2 (quotient (- y (+ (* y1 big-sqr-height) spacer top)) sml-sqr-height))
      (if (or (< x1 0) (< x2 0) (< y1 0) (< y2 0) (> x1 (- dimensions 1)) (> x2 (- dimensions 1)) (> y1 (- dimensions 1)) (> y2 (- dimensions 1)))
	  (cons (cons -1 -1) (cons -1 -1)) 
	  (cons (cons x1 y1) (cons x2 y2))))
    
    
    ;;;;; BOARD STATE PROCEDURES
    
    (define (reset-game!)  ;;; Resets the game state                                                                                                                                                  
      (clear-graphics!)
      (set! board (new-big-board))
      (reset-current-player!)
      (set! active #t)
      (draw-board)
      (if (and (not (eq? (get-current-player) 'human)) (eq? next-move-mode 'auto))
	  (driver 'go)))
    
    (define (start-game!  players)  ;;;; Procedures to start the game                                                                          
      (set! board (new-big-board))
      (reset-current-player!)
      (set! active #t)
      (clear-graphics!)
      (draw-board)
      (cond ((null? players)  (set! playerx 'human) (set! playero 'human))
	    ((null? (cdr players)) (set! playerx (car players)) (set! playero 'human))
	    (else (set! playerx (car players)) (set! playero (cadr players))))
      
      (if (and (not (eq? (get-current-player) 'human)) (eq? next-move-mode 'auto))
	  (tdriver 'go)))

    (define (valid-move? move) ;Checks if a move is valid-> move of form ( big-pos . small-pos )                                                  
      (and (pair? move)
	   (integer? (car move))
	   (integer? (cdr move))
	   (>= (car move) 1)
	   (>= (cdr move) 1)
	   (<= (car move) 9)
	   (<= (cdr move) 9)
	   (no-winner? (get-little-board board (car move)))
	   (eq? (get-who-little (get-little-board board (car move)) (cdr move)) null-value)))
    
    
    (define (valid-move-list? move-list) ; Checks to see if move-list generated by ai is of correct form                                          
      (and (pair? move-list)
	   (pair? (cdr move-list))))
    
    (define (swap-move-mode!) (set! next-move-mode (if (eq? next-move-mode 'auto) 'manual 'auto)))
    
    (define (get-move-mode-string)
      (if (eq? next-move-mode 'auto)
	  "Current move advance mode:\nAutomatic\nClick here to toggle"
	  "Current move advance mode:\n Manual\nClick here to toggle"))
    
    (define (get-current-player)  ;;; Returns either playerx or playero, the procedures.                  
      (if (eq? current-player X)
	  playerx
	  playero))
    
    (define (reset-current-player!)  ;;; Resets parameters dealing with whose turn it is and number of                                                                                                            
      (set! current-turn 0)          ;;; turns made.                                                               
      (set! moves-made 0)
      (set! current-player X))
    
    ;;; Updates current-player and number of turns, after human move                                                                                                                                                              
    (define (swap-current-player!)
    (if (= current-turn 0)
        (set! current-turn 1)
        (if(eq? current-player X)
           (begin
             (set! current-player O)
             (set! current-turn 0))
           (begin
             (set! current-player X)
             (set! current-turn 0)))))
  
    
    ;;;;; Updates current player, moves-made, and status bar after human move                                                                  
    (define (update-human-move!)
      (set! moves-made (+ moves-made 1))
      (swap-current-player!)
      (display-status!))
    
    ;;;;;; Updates current player, moves-made, and status bar after computer move                        
    (define (update-computer-move!)
      (set! moves-made (+ moves-made 2))
      (if (eq? current-player X)
	  (set! current-player O)
	  (set! current-player X))
      (set! current-turn 0)
      (display-status!))
    
    ;;;;;; Handles doing of actual move, must be sent a valid one, this            
    ;;;;;; draws the piece on the board and updates the internal board.            
    

    (define (do-valid-move! move who)
      (define coord (board-to-graphics move))
      (place-piece (remainder (- ( car move) 1) 3)
		   (quotient (- (car move) 1) 3)
		   (remainder (- (cdr move) 1) 3)
               (quotient (- (cdr move) 1) 3) who)
      
      (set-who-big! board
		    (car move)
		    (cdr move)
		    who))
    
    ;;;;; Checks the global board to see if who has one little-board at board-pos                                                      
    (define (check-and-handle-win-little board-pos who)
      (if (won-little-board? (get-little-board board board-pos) who)
	  (win-square (remainder (- board-pos 1) 3)
		      (quotient (- board-pos 1) 3)
		      who)))

    ;;;;; Checks the global board to see if who has won                                      
    (define (check-and-handle-win-big who)
      (if (won-big-board? board who) (handle-win!)))
     
    ;;;;; Checks the global board for cats game                                                                                                                                                
    (define (check-and-handle-cats-big!)
      (cond ((and active (cats-game-big? board))
         (set! active #f)
         (display-status! "Cat's game!" 'red))))
    
    (define (handle-win!)
      (if (eq? current-player X)
	  (display-status!  "Player X wins!")
      (display-status!  "Player O wins!"))
      (set! active #f))
    
    
    
    (lambda (. options)

      (cond ((null? options)
					; Human move
	     (define clicked-square (get-square (car (get-mouse-coords)) (cadr (get-mouse-coords))))
	     (define board-big (+ (caar clicked-square) 1 (* dimensions (cdar clicked-square))))
	     (define board-small (+ (cadr clicked-square) 1 (* dimensions (cddr clicked-square))))
	     (cond ((and (eq?  (get-current-player) 'human)  ;;; Check to make sure it is a human's turn                                                 
			 (> (caar clicked-square) -1)                                     ;;; Valid square click?                                        
			 (eq? (get-who-big board board-big board-small) null-value)
			 (no-winner? (get-little-board board board-big))
			 active)                                                  ;;; Board open                                                         
                                                               ;;;; HUMAN PLAYER MADE VALID MOVE                                              
		    (place-piece (caar clicked-square) (cdar clicked-square) (cadr clicked-square) (cddr clicked-square) current-player)
		    (do-valid-move! (cons board-big board-small) current-player)
		    (check-and-handle-win-little board-big current-player)
		    (check-and-handle-win-big current-player)
		    (check-and-handle-cats-big!)
		    (if active (update-human-move!))
		    (if (and (not (eq? (get-current-player) 'human)) (eq? next-move-mode 'auto))
			(driver 'go)))))	     
         
	    ((eq? (car options) 'go)
                                        ; Computer player needs to make move.
	     
	     (cond ((and   (not (eq? (get-current-player) 'human))
			   active)                     ;;; Computer move
		    (set! current-move current-player) ; In case error out
		    (let ((moves ((if (eq? current-player X) playerx playero) (make-deep-copy board) (if (eq? current-player X) X O))))
		      (cond ((not (valid-move-list? moves))   )  ;; Malformed move-list                                                                  
			    ((and (valid-move? (car moves)) (valid-move? (cadr moves)))
			     (do-valid-move! (car moves) current-player)
			     (check-and-handle-win-little (caar moves) current-player)
			     (check-and-handle-win-big current-player)
			     (check-and-handle-cats-big!)
			     (cond ((valid-move? (cadr moves))
				    (do-valid-move! (cadr moves) current-player)
				    (check-and-handle-win-little (caadr moves) current-player)
				    (check-and-handle-win-big current-player)
				    (check-and-handle-cats-big!)
				    )))
			    ((valid-move? (car moves))
			     (do-valid-move! (car moves) current-player)
			     (check-and-handle-win-little (caar moves) current-player)
			     (check-and-handle-win-big current-player)
		       
			     (check-and-handle-cats-big!))
			    ((valid-move? (cadr moves))
			     (do-valid-move! (cadr moves) current-player)
			     (check-and-handle-win-little (car (cadr moves)) current-player)
			     (check-and-handle-win-big current-player)
			     (check-and-handle-cats-big!))))
		   ;(define (won-big-board? big-board who) 
		    (cond (active
			  
			   (update-computer-move!)
			   (tdriver 'go))
			  ((won-big-board? board 'o)   'o)
			  ((won-big-board? board 'x)   'x)
			  (else '())))))
	    ((eq? (car options) 'start)
					; Start up game  
	     (start-game! (cadr options))
	     )
	    ((eq? (car options) 'reset)
	     (reset-game!)
	     )
	    (else (display "Invalid call to driver"))))))

(set-binding! 0 (lambda () (tdriver)))  ;;; Driver gets called  on mouse click.

(define tdriver (make-new-tourney-driver))


(define (tstart! . options)
  (set! tdriver (make-new-tourney-driver))
  (tdriver 'start options ))

;tstart takes in two ais



(define (offensive-ai)
  (define (AI board who)  ; AI is entry point for our AI
    
    ;code taken from Structure and Interpretation of Computer Programs
    (define (insert! key-1 key-2 value table)
      (let ((subtable (assoc key-1 (cdr table))))
	(if subtable
	    (let ((record (assoc key-2 (cdr subtable))))
	      (if record
		  (set-cdr! record value)
		  (set-cdr! subtable
			    (cons (cons key-2 value)
				  (cdr subtable)))))
	    (set-cdr! table
		      (cons (list key-1
				  (cons key-2 value))
			    (cdr table)))))
      'ok)
    
    (define (lookup key-1 key-2 table)
      (let ((subtable (assoc key-1 (cdr table))))
	(if subtable
	    (let ((record (assoc key-2 (cdr subtable))))
	      (if record
		  (cdr record)
		  #f))
	    #f)))
  
    ;our code


    ;checks to see if any of the squares have been won and makes that whole 
    ;square all x's or all o's
      (define (check-for-win board)
	(define (check-iter board char count)
	  (if (= count 10)
	      board
					;first checks to see if there's a win
	      (if (or 
		   
		   (and (eq? (lookup count 1 board) char) 
			(eq? (lookup count 2 board) char) 
			(eq? (lookup count 3 board) char))
		   (and (eq? (lookup count 4 board) char) 
			(eq? (lookup count 5 board) char) 
			(eq? (lookup count 6 board) char))
		   (and (eq? (lookup count 7 board) char) 
			(eq? (lookup count 8 board) char) 
			(eq? (lookup count 9 board) char))
		   (and (eq? (lookup count 1 board) char) 
			(eq? (lookup count 4 board) char) 
			(eq? (lookup count 7 board) char))
		   
		   (and (eq? (lookup count 2 board) char) 
			(eq? (lookup count 5 board) char) 
			(eq? (lookup count 8 board) char))
		   (and (eq? (lookup count 3 board) char) 
			(eq? (lookup count 6 board) char) 
			(eq? (lookup count 9 board) char))
		   (and (eq? (lookup count 1 board) char) 
			(eq? (lookup count 5 board) char) 
			(eq? (lookup count 9 board) char))
		   (and (eq? (lookup count 3 board) char) 
			(eq? (lookup count 5 board) char) 
			(eq? (lookup count 7 board) char))
		   )
		  (begin
		    (define (iter board space little-board char)
		      (if (= space 10)
			  (check-iter board char (+ count 1))
			  (begin (insert! little-board space char board) 
				 (iter board (+ space 1) little-board char))
			  )
		      )
		    (iter board 1 count char)
		    );ends begin
		  (check-iter board char (+ count 1))
		  );ends if
	      )
	  )
	(begin
	  (check-iter board 'o 1)
	  (check-iter board 'x 1)
	  board)
	);end check-for-win





    ;makes a table with all the values of the board in a more 
    ;easily accessable format (at least I think so)
    (define (make-table board)
      

      ;converts the board into a better format
      (define (convert board)
	(define (conv-iter board little-board)
	  (if (= 10 little-board)
	      board
	      
	      (begin
		(define (another-iter board little-board square)
		  (cond  ((= 10 square) (conv-iter board (+ little-board 1)))
			 ((null? (lookup little-board square board))
			  (another-iter board little-board (+ 1 square)))
			 (else (begin (insert! little-board square  (lookup little-board square board) board) 
				      (another-iter board little-board (+ 1 square)))))
		  )
		(another-iter board little-board 1))
	      )
	  )
	(conv-iter board 1)
	);end convert board
      
      ;adds the values into the board
      (define (iter board count board2)
	(if (= count 10)
	    board2
	    (begin (insert! count '1 (cadr (car board)) board2)
		   (insert! count '2 (caddr (car board)) board2)
		   (insert! count '3 (cadddr (car board)) board2)
		   (insert! count '4 (car (cdddr (cdr (car board)))) board2)
		   (insert! count '5 (car (cdddr (cddr (car board)))) board2)
		   (insert! count '6 (car (cdddr (cdddr (car board)))) board2)
		   (insert! count '7 (car (cdddr (cdddr (cdr (car board))))) board2)
		   (insert! count '8 (car (cdddr (cdddr (cddr (car board))))) board2)
		   (insert! count '9 (car (cdddr (cdddr (cdddr (car board))))) board2)
		   (iter (cdr board) (+ count 1) board2)
		   )
	    )
	
	)

      
					;finally returns a table
      (check-for-win (convert (iter (cdr board) 1 (list '*table*))))
      );end make-table
    
    ;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    ;move strategies

    (define (find-move board)


      ;checks to see if the square is empty
      (define (empty-square?  little-board square board)
	(null? (lookup little-board square board)))
      
      ;checks to see how many squares are full
      (define (numbers-of-moves board)
	(define (iter-little-board board count little-board)
	  (if (= 10 little-board)
	      count
	      (begin
		(define (iter-square board count little-board square-count)
		  (if (= square-count 10)
		      (iter-little-board board count (+ 1 little-board))
		
		      ;check if square is empty
		      (if (not (empty-square? little-board square-count board))
			  (iter-square board (+ 1 count) little-board (+ 1 square-count))
			  (iter-square board count little-board (+ 1 square-count))
			  )
		      )
		  )
	      
		(iter-square board count little-board 1))
	      )
	  )
	(iter-little-board board 0 1)
	)

      ;checks if a square is won, and by who
      (define (check-won little-board board)
	
	(define (checker? little-board board)
	  (and (eq? (lookup little-board 1 board) (lookup little-board 2 board))
	       (eq? (lookup little-board 2 board) (lookup little-board 3 board))
	       (eq? (lookup little-board 3 board) (lookup little-board 4 board))
	       (eq? (lookup little-board 4 board) (lookup little-board 5 board))
	       (eq? (lookup little-board 5 board) (lookup little-board 6 board))
	       (eq? (lookup little-board 6 board) (lookup little-board 7 board))
	       (eq? (lookup little-board 7 board) (lookup little-board 8 board))
	       (eq? (lookup little-board 8 board) (lookup little-board 9 board))))

	(if checker? 
	    (lookup little-board 1 board)
	    ()))

     

      ;goes in a middle square
      (define (first-move board)
	(if (> (numbers-of-moves board) 7)
	    (got-two board)
	    (if  (empty-square? 5 5 board)
		 (begin (insert! 5 5 who board)
			(cons 5 5))
		 (if (empty-square? 8 5 board)
		     (begin (insert! 8 5 who board)
			    (cons 8 5))
		     (if (empty-square? 2 5 board)
			 (begin (insert! 2 5 who board)
				(cons 2 5))
			 (if  (empty-square? 9 5 board)
			      (begin (insert! 9 5 who board)
				     (cons 9 5))
			      (if (empty-square? 7 5 board)
				  (begin (insert! 7 5 who board)
					 (cons 7 5))
				  (if (empty-square? 3 5 board)
				      (begin (insert! 3 5 who board)
					     (cons 3 5))
				      (if  (empty-square? 4 5 board)
					   (begin (insert! 4 5 who board)
						  (cons 4 5))
					   (if (empty-square? 6 5 board)
					       (begin (insert! 6 5 who board)
						      (cons 6 5))
					       (if (empty-square? 1 5 board)
						   (begin (insert! 1 5 who board)
							  (cons 1 5))
						   (get-square-with-middle board)))))))))))
					
	);end first move





      ;will attempt to get another board
      (define (got-two board)
	(define (iter board little-board)
	  (if (= little-board 7)
	      (get-square-with-middle board)
	      (if (and
		   (eq? (check-won little-board board) who)
		   (eq? (check-won little-board board) (check-won (+ 3 little-board) board))) 
		  (if (< 4 little-board)
		      (begin (set! move2 (car (get-two-in-row board (- little-board 3))))
			     (cdr (get-two-in-row board (- little-board 3))))
		      
		      (begin (set! move2 (car (get-two-in-row board (+ little-board 6))))
			     (cdr (get-two-in-row board (+ little-board 6)))))
		  (iter board (+ 1 little-board))
		  )
	      ))
	(iter board 1)
	)
      

      (define (get-two-in-row board little-board)
	;checks for possible three in a rows horizontally
	(define (iter-horiz board little-board square)
	  (if (= 10 square)
	      (iter-vert board little-board 1)
	      (if (and (empty-square? little-board square board)
		       (empty-square? little-board (+ 1 square) board)
		       (empty-square? little-board (+ 2 square) board))
		  (cons (cons little-board square) (cons little-board (+ 1 square)))
		  (iter-horiz board little-board (+ square 3))
	       )))

	;if there aren't any it checks for them vertically
	(define (iter-vert board little-board square)
	  (if (= 4 square)
	      (cons (last-move board) (last-move board))
	      (if (and (empty-square? little-board square board)
		       (empty-square? little-board (+ 3 square) board)
		       (empty-square? little-board (+ 6 square) board))
		  (cons (cons little-board square) (cons little-board (+ 3 square)))
		  (iter-vert board little-board (+ square 1))
		  )))
	(iter-horiz board little-board 1))

      ;attempts to make three in a row if it has the middle square
      (define (get-square-with-middle board)
	
	(if (not (null? move1))
	    ;on the second move, finish off the win of the square
	    (begin
	    (define (second-opposites board)
	      (if (empty-square? (car move1) (- 10 (cdr move1)) board)
		  (cons (car move1) (- 10 (cdr move1)))
		  (last-move board)
	      )
	    )
	    (second-opposites board))


	    ;otherwise, it tries to get an empty square with another 
	    ;empty square across from it
	    (begin
	    (define (iter board little-board)
	      (if (= 10 little-board)
		  (last-move board)
		  (if (eq? (lookup little-board 5 board) who)
		      (begin
			
		    ;finds the best three in a row place
			(define (check-opposites board little-board)
			  (define (iter-opposites board little-board count)
			    (if (= count 10)
				(iter board (+ 1 little-board))
				(if (and (empty-square? little-board count board)
					 (empty-square? little-board (- 10 count) board))
				    (cons little-board (- 10 count))
				    (iter-opposites board little-board (+ 1 count))
				    )
				)
			    )
			  (iter-opposites board little-board 1))
			
			
			(check-opposites board little-board))
		      (iter board (+ 1 little-board))
		      )
		  )
	      )
	    (iter board 1))
	 )
      );end get square with middle


      	

      ;go into the first open square
      (define (last-move board)
      
	  (define (iter-little-board board move little-board)
	    (if (= 10 little-board)
		move

(begin
		(define (iter-square board little-board square)
		  (if (= 10 square)
		      (iter-little-board board () (+ 1 little-board))
		      (if (empty-square? little-board square board)
			  (begin (insert! little-board square who board)
				 (iter-little-board board (cons little-board square) 10))
			  (iter-square board little-board (+ 1 square))
		      )
		   )
		)
		(iter-square board little-board 1))
	     )
	  )
	  (iter-little-board board () 1)
	);end last move


      
      (first-move board)
   );ends find move



    (begin
      (define move1 ())
      (define move2 ())
      (define our-board (make-table board))

      (define move1 (find-move our-board))
      (check-for-win our-board)
      (if (null? move2)
         (define move2 (find-move our-board))
      )
      (list  move1 move2)
    )

    );ends AI
  AI    ; AI (which operates in the environment referred to as the
        ; local state above) is returned from a call to make-ai
  )
;;;(define eckh0027 make-ai)    ; create my-ai as AI in local state


;;; Super Tic-Tac-Toe Grading Code Starts Here

;offensive-ai and random-ai


(define (r-ai) random-ai)

(define opponent-list
  (list
   r-ai
   r-ai
   r-ai
   r-ai
   r-ai
   r-ai
   offensive-ai
   offensive-ai
   offensive-ai
   )
)

;(define ai-list (list ))


;;;; Tourney Driver code starts here


(define winvec '())
(define tievec '())
(define loosevec '())
(define errorvec '())

(define list-pos1  0 )
(define list-pos2  0 )
(define current-move '())
(define current-type '())

;(define ai-list '())

(define (print-results)
  (define (iter x)
    (if (= x (length ai-list))
	'()
	(begin 
	  (display (list-ref ai-names x))
	  (display ":\t")
	  (display (vector-ref winvec x))
	  (display "\t")
	  (display (vector-ref loosevec x))
	  (display "\t")
	  (display (vector-ref tievec x))
	  (display "\t")
	  (display (+ (vector-ref tievec x)
		      (* 2 (vector-ref winvec x))
		      14))
	  (newline)
	  (iter (1+ x))
	  )
    ))
  (iter 0)
  )





(define (grader option)

  (define (setup n)
  ; Defines vectors and sets to n 
    (set! winvec (make-vector n 0 ))
    (set! tievec (make-vector n 0 ))
    (set! loosevec (make-vector n 0))
    (set! errorvec (make-vector n 0))
    (set! list-pos1 0)
    (set! list-pos2 0)
    )



  (define (do-x-game n1 n2)
    (let ((playerx (list-ref ai-list n1))
	  (playero (list-ref opponent-list n2))
	  )
      (set! tdriver (make-new-tourney-driver))
      (display "Starting X  game\n")
      (let ((winner (tstart! (playerx) (playero))))
	(cond ((eq? winner 'o)
	     (vector-set! loosevec n1 (1+ (vector-ref loosevec n1))))
	    ((eq? winner 'x)
	     (vector-set! winvec n1 (1+ (vector-ref winvec n1))))
	    ((eq? winner ())
	     (vector-set! tievec n1 (1+ (vector-ref tievec n1)))))))
    (set! current-move '()))


  (define (do-o-game n1 n2)
    (let ((playero (list-ref ai-list n1))
	  (playerx (list-ref opponent-list n2))
	  )
      (set! tdriver (make-new-tourney-driver))
      (display "Starting O  game\n")
      (let ((winner (tstart! (playerx) (playero))))
	(cond ((eq? winner 'o)
	     (vector-set! winvec n1 (1+ (vector-ref winvec n1))))
	    ((eq? winner 'x)
	     (vector-set! loosevec n1 (1+ (vector-ref loosevec n1))))
	    ((eq? winner ())
	     (vector-set! tievec n1 (1+ (vector-ref tievec n1)))))))
    (set! current-move '()))

  (define (continue)
    (cond ((and (eq? current-type 'x) (eq? current-move X) )     
	   (vector-set! loosevec list-pos1 (1+ (vector-ref loosevec list-pos1)))
	   (set! current-move ())

	   (continue)
	   )
	  ((and (eq? current-type 'o) (eq? current-move O) )
	   (vector-set! loosevec list-pos1 (1+ (vector-ref loosevec list-pos1)))
	   (set! current-move ())
	   
	   (continue)
	   )
	  ((or (and (eq? current-type 'x) (eq? current-move O))
	       (and (eq? current-type 'o) (eq? current-move X)))
	   ; Testing AI produced an error
	   (display "TEST AI ERROR")
	   (vector-set! winvec list-pos1 (1+ (vector-ref winvec list-pos1)))
	   (set! current-move ())
	   (continue)

	   )

	  ((= list-pos2 (length opponent-list))
	   (set! list-pos2 0)
	   (set! list-pos1 (1+ list-pos1))
	   (continue)
	   )

	  ((= list-pos1 (length ai-list))
	   (display "Continue finished! All games ran \n")

	   )
	  	  
	  ((eq? current-type 'o)
	   ;;;  Switch to an 'x game
	   (set! list-pos2 (1+ list-pos2))
	   (set! current-type ())
	   (continue)
	   )

	  ((eq? current-type 'x)
	   ;;;  Switch to an 'o game
	   (set! current-type 'o)
	   (do-o-game list-pos1 list-pos2)
	   (continue)
	   )

	  ((eq? current-type ())
	   ;;; Do x game
	   (set! current-type 'x)
	   (do-x-game list-pos1 list-pos2)
	   (continue)
	   )
	  (else
	    (display "SHOULDN'T BE HERE")
           )))

  (cond ((eq? option 's) (setup (length ai-list)) (continue) )
	((eq? option 'c ) (continue)  )))



(define (c) (grader 'c))