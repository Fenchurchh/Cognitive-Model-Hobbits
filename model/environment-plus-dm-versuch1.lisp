


(clear-all)
(define-model env-model
(sgp :esc t :lf .05 :ans 0.5 :trace-detail high)
(act-r-noise 0.5)

(setf *old* 1)

(chunk-type state currentTask hobbitsLeft orcsLeft boatLeft plannedLeftHobbits plannedLeftOrcs)
(chunk-type task hobbitsMove orcsMove boatMove)
(chunk-type waypoint step hobbitsLeft orcsLeft )
(chunk-type evaluateOptions target)



(add-dm
	(findTask ISA chunk)
	(checkMovementForValidity ISA chunk)

	(move10 ISA task hobbitsMove 1 orcsMove 0)
	(move01 ISA task hobbitsMove 0 orcsMove 1)
	(move11 ISA task hobbitsMove 1 orcsMove 1)
	(move20 ISA task hobbitsMove 2 orcsMove 0)
	(move02 ISA task hobbitsMove 0 orcsMove 2)

	(negativeMove10 ISA task hobbitsMove -1 orcsMove 0)
	(negativeMove01 ISA task hobbitsMove 0 orcsMove -1)
	(negativeMove11 ISA task hobbitsMove -1 orcsMove -1)
	(negativeMove20 ISA task hobbitsMove -2 orcsMove 0)
	(negativeMove02 ISA task hobbitsMove 0 orcsMove -2)
 
	(goal ISA state currentTask nil hobbitsLeft 3 orcsLeft 3 boatLeft 1)
 )


(p start 
	=goal>
		ISA 				state
		currentTask 		nil
		hobbitsLeft 		=h
		orcsLeft 			=o
		!eval! (print 'search-move)
		!eval! (print  (concatenate 'string (write-to-string =h) "H" (write-to-string =o) "O") )

==>
	+retrieval>
		ISA 				task
	=goal>
		currentTask			findTask
)


(p modifyProblem
	=goal>
		ISA					state
		currentTask 		findTask
		hobbitsLeft			=oldHobbitsLeft
		orcsLeft 			=oldOrcsLeft
	=retrieval>
		ISA 				task
		hobbitsMove 		=moveh
		orcsMove			=moveo
		!bind! 				=newHobbitsLeft (- =oldHobbitsLeft =moveh)
		!bind! 				=newOrcsLeft (- =oldOrcsLeft =moveo)
==>
	=goal>
		plannedLeftHobbits 	=newHobbitsLeft
		plannedLeftOrcs 	=newOrcsLeft
		currentTask			checkMovementForValidity
)


; we check our current planned move for validity
; i.e. THere are equal or more than 0 ORCS/HOBBITS on the left side of the river
(p moveIsValid
		!eval! (print 'valid-move)
	=goal>
		ISA 				state
		currentTask 		checkMovementForValidity
		> plannedLeftOrcs 		0
		> plannedLeftHobbits 	0
==>
	=goal>
		currentTask FUCKYEAHLETSDOIT

)

(p moveIsInValid_Hobbits
		!eval! (print 'invalid-move-HOBBITS)
	=goal>
		ISA 				state
		currentTask 		checkMovementForValidity
		< plannedLeftHobbits 	0
==>
	=goal>
		currentTask nil
)


(p moveIsInvalid_Orcs	
	!eval! (print 'invalid-move-ORCS)
	=goal>
		ISA 				state
		currentTask 		checkMovementForValidity
		< plannedLeftOrcs 		0
	
==>
	=goal>
		currentTask nil
)


;; FUCK YEAH LETS DO IT
;; we move planned Movement into actual movement
(p actualize
		!eval! (print 'perform-move)
	=goal>
		ISA 				state
		currentTask 		FUCKYEAHLETSDOIT
		plannedLeftHobbits	=newHobbitsLeft
		plannedLeftOrcs		=newOrcsLeft
==>
	=goal>
		currentTask 		nil
		hobbitsLeft 		=newHobbitsLeft
		orcsLeft 			=newOrcsLeft

)



(p judgeALL
		!eval! (print 'are-we-done-yet)
	=goal>
		ISA 				state
		currentTask			nil
		hobbitsLeft 		0
		orcsLeft 			0
==>
	=goal>
		currentTask			finish
		!eval! (print 'done)		
)


(goal-focus goal)
)
