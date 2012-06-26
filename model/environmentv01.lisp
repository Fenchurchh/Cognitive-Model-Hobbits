(setf *decisions* nil)

(defun start (number time)
	(reset-all)
	(dotimes (i number)
		;Achtung: Der goal Focus für die einzelnen Durchläufe muss hier gesetzt werden.
		(goal-focus test-state)
		(run time)
		(print *decisions*)
		(print *times*))
)

(defun save-decision (hobbits-links hobbits-rechts orcs-links orcs-rechts)
	(let ((code (concatenate 'string (write-to-string hobbits-links) "H" (write-to-string orcs-links) "O-" (write-to-string hobbits-rechts) "H" (write-to-string orcs-rechts) "O"))
		  (judge (if (or (and (> hobbits-links 0) (> orcs-links hobbits-links)) (and (> hobbits-rechts 0) (> orcs-rechts hobbits-rechts))) 0 1)))
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




(define-model env-model

(sgp :esc t :lf .05 :trace-detail high)


(chunk-type state hl hr ol or)


(add-dm
	(test-state ISA state hl 2 hr 1 ol 2 or 1)
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

)
