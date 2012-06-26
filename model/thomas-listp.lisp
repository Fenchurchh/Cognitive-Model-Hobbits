(defun start (number time)
	(reset-all)
	(dotimes (i number)
		;Achtung: Der goal Focus für die einzelnen Durchläufe muss hier gesetzt werden.
		(goal-focus test-legalPosition)
		(run time)
		(print *decisions*)
		(print *times*))
)

(defun save-decision (hl hobbitsRight orcsLeft or)
	(let ((code (concatenate 'string (write-to-string hl) "H" (write-to-string orcsLeft) "O-" (write-to-string hobbitsRight) "H" (write-to-string or) "O"))
		  (judge (if (or (< hobbitsLeft orcsLeft) (< hobbitsRight or)) 0 1)))
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


(chunk-type legalPosition hobbitsLeft hobbitsRight orcsLeft orcsRight boat)
(chunk-type count-order first second)				;um den Slot 'boat' erweitert
(chunk-type add arg1 arg2)
(chunk-type sub arg1 arg2)
(chunk-type schaff-es hobbitsLeft hobbitsRight orcsLeft orcsRight boat state)

(add-dm
	(s320 ISA legalPosition hobbitsLeft 3 hobbitsRight 0 orcsLeft 2 orcsRight 1 boat 0)	;hier sind nur die legalen Züge des Problemraums von Studie Seite 259 gelistet,
	(s331 ISA legalPosition hobbitsLeft 3 hobbitsRight 0 orcsLeft 3 orcsRight 0 boat 1)	;die illegalen müssten am besten über eine Produktionsregel laufen, 
	(s220 ISA legalPosition hobbitsLeft 2 hobbitsRight 1 orcsLeft 2 orcsRight 1 boat 0)	;welche z.B. "nein-nein" ausgibt und in einen vorherigen
	(s310 ISA legalPosition hobbitsLeft 3 hobbitsRight 0 orcsLeft 1 orcsRight 2 boat 0)	;oder irgendwie verbundenen 'legalen' Bufferzustand 'zurückkehobbitsRightt 
	(s321 ISA legalPosition hobbitsLeft 3 hobbitsRight 0 orcsLeft 2 orcsRight 1 boat 1)	;oder wir schobbitsRighteiben ALLE Zustände in das DM, da hab ich grad keinen Bock zu 
	(s300 ISA legalPosition hobbitsLeft 3 hobbitsRight 0 orcsLeft 0 orcsRight 3 boat 0)	;und ist vielleicht/wahobbitsRightscheinlich auch nicht nötig!
	(s311 ISA legalPosition hobbitsLeft 3 hobbitsRight 0 orcsLeft 1 orcsRight 2 boat 1)
	(s110 ISA legalPosition hobbitsLeft 1 hobbitsRight 2 orcsLeft 1 orcsRight 2 boat 0)	;der goal-focus setzt bei chunk 331 an
	(s221 ISA legalPosition hobbitsLeft 2 hobbitsRight 1 orcsLeft 2 orcsRight 1 boat 1)
	(s020 ISA legalPosition hobbitsLeft 0 hobbitsRight 3 orcsLeft 2 orcsRight 1 boat 0)
	(s031 ISA legalPosition hobbitsLeft 0 hobbitsRight 3 orcsLeft 3 orcsRight 0 boat 1)
	(s010 ISA legalPosition hobbitsLeft 0 hobbitsRight 3 orcsLeft 1 orcsRight 2 boat 0)
	(s021 ISA legalPosition hobbitsLeft 0 hobbitsRight 3 orcsLeft 2 orcsRight 1 boat 1)
	(s111 ISA legalPosition hobbitsLeft 1 hobbitsRight 2 orcsLeft 2 orcsRight 1 boat 1)
	(s000 ISA legalPosition hobbitsLeft 0 hobbitsRight 3 orcsLeft 0 orcsRight 3 boat 0)
	(a ISA count-order first 0 second 1)
    (b ISA count-order first 1 second 2)
    (c ISA count-order first 2 second 3)
    (add-goal1 ISA add arg1 0 arg2 2)
    (add-goal2 ISA add arg1 0 arg2 1)
    (add-goal3 ISA add arg1 1 arg2 2)
    (add-goal4 ISA add arg1 1 arg2 1)
    (add-goal5 ISA add arg1 2 arg2 1)
    (sub-goal1 ISA sub arg1 3 arg2 2)
    (sub-goal2 ISA sub arg1 3 arg2 1)
    (sub-goal3 ISA sub arg1 2 arg2 2)
    (sub-goal4 ISA sub arg1 2 arg2 1)
    (sub-goal5 ISA sub arg1 1 arg2 1)

    (goal ISA positionStart hobbitsLeft 3 hobbitsRight 0 orcLinks 3 orcsRight 0 boat 1 state)
 )

(p start
   =goal>
		ISA         	positionStart
		hl				=hl
		hobbitsRight				=hobbitsRight
		orcsLeft				=orcsLeft
		or				=or
==>
   =goal>
   +imaginal>
   		isa 			legalPosition
		hl				=hl
		hobbitsRight				=hobbitsRight
		orcsLeft				=orcsLeft
		or				=or
)

(p zwischenzustand1
	=imaginal>
		ISA 			legalPosition
		hl				=hl
==>
	+retrieval>
		ISA 			sub
		arg1			=hl
)

(p zwischenzustand2
	=retrieval>
		isa 			sub
		arg2			=new
==>
	=imaginal>
		hl				=new
)

(P increment-sum
   =goal>
      ISA         add
      sum         =sum
      count       =count
    - arg2        =count
   =retrieval>
      ISA         count-order
      first       =sum
      second      =newsum
==>
   =goal>
      sum         =newsum
   +retrieval>
      isa        count-order
      first      =count
)

(p test
   =goal>
		ISA         	legalPosition
		hl				=hl
		hobbitsRight				=hl
		orcsLeft				=hl
		or				=hl
	==>
	!eval! (save-decision =hl =hl =hl =hl)
	!eval! (save-time)
   -goal>
	
)

(goal-focus schaff-es)
)
