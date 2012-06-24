(defun start (number time)
	(reset-all)
	(dotimes (i number)
		;Achtung: Der goal Focus für die einzelnen Durchläufe muss hier gesetzt werden.
		(goal-focus test-state)
		(run time)
		(print *decisions*)
		(print *times*))
)

(defun save-decision (hl hr ol or)
	(let ((code (concatenate 'string (write-to-string hl) "H" (write-to-string ol) "O-" (write-to-string hr) "H" (write-to-string or) "O"))
		  (judge (if (or (< hl ol) (< hr or)) 0 1)))
		(setf *decisions* (acons code judge *decisions*)))
)

(defun save-time ()
	(setf *times* (cons (- (get-time) (first (last *times*))) *times*))
)

(defun reset-all ()
	(setf *decisions* nil)
	(setf *times* (list (get-time)))
	;(reset)
	;(clear-all)
)




(define-model env-model2

(sgp :esc t :lf .05 :trace-detail high)


(chunk-type state currentTask hobbitsLeft orcsleft boatLeft)
(chunk-type task lastTask hobbitsMove orcsMove boatMove)

(add-dm
	(move10 ISA task hobbitsMove 1 orcsMove 0)
	(move01 ISA task hobbitsMove 0 orcsMove 1)
	(move11 ISA task hobbitsMove 1 orcsMove 1)
	(move20 ISA task hobbitsMove 2 orcsMove 0)
	(move02 ISA task hobbitsMove 0 orcsMove 0)
 
	(goal isa state currentTask evaluateOptions hobbitsLeft 3 orcsLeft 3 boatLeft 1)
 )

(p evaluateOptions
	=goal>
		ISA 	state
		currentTask 	evaluateOptions
	==>
		=goal>
			ISA 	state
			currentTask findNewTask

)


(p findNewTask 
	=goal>
		ISA 	state
		currentTask 	findNewTask

	==>
		=goal>
			ISA state
			currentTask searchingTask

)


(p start
   =goal>
		ISA         	state
		hl				=hl
		hr				=hr
		ol				=ol
		or				=or
	==>
	!eval! (save-decision =hl =hr =ol =or)
	!eval! (save-time)
   =goal>
		hl				=hl
		hr				=hl
		ol				=hl
		or				=hl
)

(p test
   =goal>
		ISA         	state
		hl				=hl
		hr				=hl
		ol				=hl
		or				=hl
	==>
	!eval! (save-decision =hl =hl =hl =hl)
	!eval! (save-time)
   -goal>
	
)

(goal-focus start)
)
