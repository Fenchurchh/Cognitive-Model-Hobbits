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




(define-model env-model

(sgp :esc t :lf .05 :trace-detail high)


(chunk-type state hl hr ol or boat)
(chunk-type count-order first second)				;um den Slot 'boat' erweitert
(chunk-type add arg1 arg2)
(chunk-type sub arg1 arg2)
(chunk-type schaff-es hl hr ol or boat status)

(add-dm
	(s320 ISA state hl 3 hr 0 ol 2 or 1 boat 0)	;hier sind nur die legalen Züge des Problemraums von Studie Seite 259 gelistet,
	(s331 ISA state hl 3 hr 0 ol 3 or 0 boat 1)	;die illegalen müssten am besten über eine Produktionsregel laufen, 
	(s220 ISA state hl 2 hr 1 ol 2 or 1 boat 0)	;welche z.B. "nein-nein" ausgibt und in einen vorherigen
	(s310 ISA state hl 3 hr 0 ol 1 or 2 boat 0)	;oder irgendwie verbundenen 'legalen' Bufferzustand 'zurückkehrt 
	(s321 ISA state hl 3 hr 0 ol 2 or 1 boat 1)	;oder wir schreiben ALLE Zustände in das DM, da hab ich grad keinen Bock zu 
	(s300 ISA state hl 3 hr 0 ol 0 or 3 boat 0)	;und ist vielleicht/wahrscheinlich auch nicht nötig!
	(s311 ISA state hl 3 hr 0 ol 1 or 2 boat 1)
	(s110 ISA state hl 1 hr 2 ol 1 or 2 boat 0)	;der goal-focus setzt bei chunk 331 an
	(s221 ISA state hl 2 hr 1 ol 2 or 1 boat 1)
	(s020 ISA state hl 0 hr 3 ol 2 or 1 boat 0)
	(s031 ISA state hl 0 hr 3 ol 3 or 0 boat 1)
	(s010 ISA state hl 0 hr 3 ol 1 or 2 boat 0)
	(s021 ISA state hl 0 hr 3 ol 2 or 1 boat 1)
	(s111 ISA state hl 1 hr 2 ol 2 or 1 boat 1)
	(s000 ISA state hl 0 hr 3 ol 0 or 3 boat 0)
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
    (goal ISA schaff-es hl 3 hr 0 ol 3 or 0 boat 1 status)
 )

(p start
   =goal>
		ISA         	state
		hl				=hl
		hr				=hr
		ol				=ol
		or				=or
==>
   =goal>
   +imaginal>
   		isa 			state
		hl				=hl
		hr				=hr
		ol				=ol
		or				=or
)

(p zwischenzustand1
	=imaginal>
		ISA 			state
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

(goal-focus schaff-es)
)
