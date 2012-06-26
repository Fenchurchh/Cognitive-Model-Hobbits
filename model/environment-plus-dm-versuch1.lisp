


(clear-all)
(define-model env-model

(sgp :esc t :lf .05 :trace-detail high)



(chunk-type state currentTask hobbitsLeft orcsleft boatLeft)
(chunk-type task hobbitsMove orcsMove boatMove)
(chunk-type waypoint step hobbitsLeft orcsLeft )
(chunk-type evaluateOptions target)


(add-dm
	(findTask ISA chunk)
	(move10 ISA task hobbitsMove 1 orcsMove 0)
	(move01 ISA task hobbitsMove 0 orcsMove 1)
	(move11 ISA task hobbitsMove 1 orcsMove 1)
	(move20 ISA task hobbitsMove 2 orcsMove 0)
	(move02 ISA task hobbitsMove 0 orcsMove 2)
 
	(goal ISA state currentTask nil hobbitsLeft 3 orcsLeft 3 boatLeft 1)
 )


(p start 
	=goal>
		ISA state
		currentTask nil

==>
	+retrieval>
		ISA 	task
	=goal>
		currentTask findTask
)


(p modifyProblem
	=goal>
		ISA				state
		currentTask 	=findTask
	=retrieval>
		ISA 	task
		hobbitsMove 	=moveh
		orcsMove		=moveo
==>
	=goal>
		hobbitsLeft  	=moveh
		orcsLeft 		=moveo
		currentTask		nil

)






)
