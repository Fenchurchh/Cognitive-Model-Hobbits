
(clear-all)
(define-model env-model
(sgp :esc t :lf .05  :ans 0.55 :bll 1 :ul T  :trace-detail low :ult T)

(setf *old* 1)

(chunk-type state currentTask hobbitsLeft hobbitsRight orcsLeft
orcsRight boatLeft plannedLeftHobbits plannedRightHobbits
plannedLeftOrcs plannedRightOrcs moveHobbits moveOrcs )
(chunk-type notagain oldhobbitsLeft oldhobbitsRight oldorcsLeft oldorcsRight)



(add-dm
  (findTask ISA chunk)
  (start ISA chunk)
  (validateMove ISA chunk)
  (checkLeftSide ISA chunk)
  (checkRightSide ISA chunk)
  (testforOldState ISA chunk)


  (goal ISA state currentTask start hobbitsLeft 3 orcsLeft 3
hobbitsRight 0 orcsRight 0  boatLeft 1 moveOrcs 0 moveHobbits 0 )
 )

;; Start looking for a task (taskLeft) that transfers orcs and hobbits from left to right.
;; We assume that the boat ist on the left side with boatLeft = 1
;;
(p start-adventure
;; !eval! (print 'start-adventure)
  =goal>
   ISA     			state
   currentTask   	start
   hobbitsLeft   	=h
   orcsLeft    		=o
   boatLeft    		=b
   !eval! (print  (concatenate 'string (write-to-string =h)
(write-to-string =o) (write-to-string =b)) )
==>
  =goal>
		currentTask   	findTask
  +imaginal>
		ISA					notagain
		oldhobbitsLeft		3
		oldhobbitsRight		0
		oldorcsLeft			3
		oldorcsRight		0
)

;;
(p FINISH
   ;;!eval! (print 'well done)
  =goal>
   ISA     			state
   currentTask   	start
   hobbitsLeft   	0
   orcsLeft      	0
   boatLeft      	0
==>
  =goal>
   currentTask   	nil
)

(p anotherAproach
   =goal>
     ISA 			state
     currentTask 	find_new_solution
==>
   =goal>
     currentTask 	findTask
)



;;
;; Transformations for the left side of the river
;;;

(p transformationOneNull
   =goal>
     ISA 			state
     currentTask 	findTask
     boatLeft 		1
     >= hobbitsLeft 1
==>
   =goal>
     currentTask   	validateMove
     moveHobbits   	1
     moveOrcs      	0
)


(p transformationTwoNull
   =goal>
     ISA 			state
     currentTask 	findTask
     boatLeft 		1
     >= hobbitsLeft 2
==>
   =goal>
     currentTask   	validateMove
     moveHobbits   	2
     moveOrcs      	0
)


(p transformationOneOne
   =goal>
     ISA 			state
     currentTask 	findTask
     boatLeft 		1
     >= hobbitsLeft 1
     >= orcsLeft 	1
==>
   =goal>
     currentTask   	validateMove
     moveHobbits   	1
     moveOrcs      	1
)


(p transformationNullOne
   =goal>
     ISA 			state
     currentTask 	findTask
     boatLeft 		1
     >= orcsLeft 	1
==>
   =goal>
     currentTask   	validateMove
     moveHobbits   	0
     moveOrcs      	1
)


(p transformationNullTwo
   =goal>
     ISA 			state
     currentTask 	findTask
     boatLeft 		1
     >= orcsLeft 	2
==>
   =goal>
     currentTask   	validateMove
     moveHobbits   	0
     moveOrcs      	2
)


;;
;; Transformations for the RIGHT side of the river
;;;


(p RIGHT_transformationOneNull
   =goal>
     ISA 				state
     currentTask 		findTask
     boatLeft 			0
     >= hobbitsRight 	1
==>
   =goal>
     currentTask   		validateMove
     moveHobbits   		-1
     moveOrcs      		0
)


(p RIGHT_transformationTwoNull
   =goal>
     ISA 				state
     currentTask 		findTask
     boatLeft 			0
     >= hobbitsRight 	2
==>
   =goal>
     currentTask   		validateMove
     moveHobbits   		-2
     moveOrcs     		0
)


(p RIGHT_transformationOneOne
   =goal>
     ISA 				state
     currentTask 		findTask
     boatLeft 			0
     >= hobbitsRight 	1
     >= orcsRight 		1
==>
   =goal>
     currentTask   		validateMove
     moveHobbits   		-1
     moveOrcs      		-1
)


(p RIGHT_transformationNullOne
   =goal>
     ISA 				state
     currentTask 		findTask
     boatLeft 			0
     >= orcsRight 		1
==>
   =goal>
     currentTask   		validateMove
     moveHobbits   		0
     moveOrcs      		-1
   )


(p RIGHT_transformationNullTwo
   =goal>
     ISA 				state
     currentTask 		findTask
     boatLeft 			0
     >= orcsRight 		2
==>
   =goal>
     currentTask   		validateMove
     moveHobbits  		0
     moveOrcs      		-2
)


;;
;; SET our "planned" world state - so we can evaluate the anticipated turn
;;;

(p setImaginaryWorld
   =goal>
     ISA   				state
     currentTask 		validateMove
     moveHobbits 		=movedHobbits
     moveOrcs    		=movedOrcs
     orcsLeft    		=oldOrcsLeft
     orcsRight   		=oldOrcsRight
     hobbitsLeft 		=oldHobbitsLeft
     hobbitsRight 		=oldHobbitsRight
==>
   !bind!     =newHobbitsLeft (- =oldHobbitsLeft =movedHobbits)
   !bind!     =newOrcsLeft (- =oldOrcsLeft =movedOrcs)
   !bind!     =newHobbitsRight (+ =oldHobbitsRight =movedHobbits)
   !bind!     =newOrcsRight (+ =oldOrcsRight =movedOrcs)
   =goal>
     currentTask         checkLeftSide
     plannedLeftHobbits  =newHobbitsLeft
     plannedLeftOrcs     =newOrcsLeft
     plannedRightHobbits =newHobbitsRight
     plannedRightOrcs    =newOrcsRight
)


;;
;; CHECK LEFT SIDE
;;;

(p LEFT_moveIsInValid_HobbitsGetEaten1
  ;; !eval! (print 'invalid-move-HOBBITSareDEAD)
  =goal>
   ISA     				state
   currentTask   		checkLeftSide
   plannedLeftHobbits   1
   > plannedLeftOrcs    1
==>
  =goal>
   currentTask 			find_new_solution
)


(p LEFT_moveIsInValid_HobbitsGetEaten2
  ;; !eval! (print 'invalid-move-HOBBITSareDEAD)
  =goal>
   ISA     				state
   currentTask   		checkLeftSide
   plannedLeftHobbits   2
   > plannedLeftOrcs   	2
==>
  =goal>
   currentTask 			find_new_solution
)


(p LEFT_moveIsValid_NO-HobbitsGetEaten1
  ;; !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
  =goal>
   ISA     				state
   currentTask   		checkLeftSide
   plannedLeftHobbits   1
   <= plannedLeftOrcs   1
==>
  =goal>
   currentTask 			checkRightSide
)

(p LEFT_moveIsValid_NO-HobbitsGetEaten2
;;  !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
  =goal>
   ISA     				state
   currentTask   		checkLeftSide
   plannedLeftHobbits   2
   <= plannedLeftOrcs   2
==>
  =goal>
   currentTask 			checkRightSide
)

(p LEFT_moveIsValid_NO-HobbitsGetEaten3
;;  !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
  =goal>
   ISA     				state
   currentTask   		checkLeftSide
   plannedLeftHobbits   3
==>
  =goal>
   currentTask 			checkRightSide
)


(p LEFT_moveIsValid_NO-HobbitsGetEaten4
;;  !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
  =goal>
   ISA     				state
   currentTask   		checkLeftSide
   plannedLeftHobbits   0
==>
  =goal>
   currentTask 			checkRightSide
)


;;
;; CHECK RIGHT SIDE
;;;

(p RIGHT_moveIsInValid_HobbitsGetEaten1
;;  !eval! (print 'invalid-move-HOBBITSareDEAD)
  =goal>
   ISA     				state
   currentTask   		checkRightSide
   plannedRightHobbits  1
   > plannedRightOrcs   1
==>
  =goal>
   currentTask 			find_new_solution
)


(p RIGHT_moveIsInValid_HobbitsGetEaten2
;;  !eval! (print 'invalid-move-HOBBITSareDEAD)
  =goal>
   ISA     				state
   currentTask   		checkRightSide
   plannedRightHobbits  2
   > plannedRightOrcs   2
==>
  =goal>
   currentTask 			find_new_solution
)


(p RIGHT_moveIsValid_NO-HobbitsGetEaten1
;;  !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
  =goal>
   ISA     				state
   currentTask   		checkRightSide
   plannedRightHobbits  1
   <= plannedRightOrcs  1
==>
  =goal>
   currentTask 			testforOldState
)

(p RIGHT_moveIsValid_NO-HobbitsGetEaten2
  ;; !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
  =goal>
   ISA     				state
   currentTask   		checkRightSide
   plannedRightHobbits  2
   <= plannedRightOrcs  2
==>
  =goal>
   currentTask 			testforOldState
)

(p RIGHT_moveIsValid_NO-HobbitsGetEaten3
;;  !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
  =goal>
   ISA     				state
   currentTask   		checkRightSide
   plannedRightHobbits  3
==>
  =goal>
   currentTask 			testforOldState
)

(p RIGHT_moveIsValid_NO-HobbitsGetEaten4
;;  !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
  =goal>
   ISA     				state
   currentTask   		checkRightSide
   plannedRightHobbits  0
==>
  =goal>
   currentTask 			testforOldState
)


;;
;; we try to avoid old states
;;;

(p testforOldState-invalid
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
		oldhobbitsLeft		=hl
		oldhobbitsRight		=hr
		oldorcsLeft			=ol
		oldorcsRight		=or
==>
	=goal>
		currentTask			find_new_solution
)

(p testforOldState-valid1
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
	-	oldhobbitsLeft		=hl
	-	oldhobbitsRight		=hr
	-	oldorcsLeft			=ol
	-	oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)

(p testforOldState-valid2
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
		oldhobbitsLeft		=hl
	-	oldhobbitsRight		=hr
	-	oldorcsLeft			=ol
	-	oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)

(p testforOldState-valid3
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
	-	oldhobbitsLeft		=hl
		oldhobbitsRight		=hr
	-	oldorcsLeft			=ol
	-	oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)

(p testforOldState-valid4
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
	-	oldhobbitsLeft		=hl
	-	oldhobbitsRight		=hr
		oldorcsLeft			=ol
	-	oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)

(p testforOldState-valid5
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
	-	oldhobbitsLeft		=hl
	-	oldhobbitsRight		=hr
	-	oldorcsLeft			=ol
		oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)

(p testforOldState-valid6
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
		oldhobbitsLeft		=hl
		oldhobbitsRight		=hr
	-	oldorcsLeft			=ol
	-	oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)

(p testforOldState-valid7
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
	-	oldhobbitsLeft		=hl
		oldhobbitsRight		=hr
		oldorcsLeft			=ol
	-	oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)

(p testforOldState-valid
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
	-	oldhobbitsLeft		=hl
	-	oldhobbitsRight		=hr
		oldorcsLeft			=ol
		oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)
	
(p testforOldState-valid8
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
		oldhobbitsLeft		=hl
	-	oldhobbitsRight		=hr
	-	oldorcsLeft			=ol
		oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)

(p testforOldState-valid9
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
		oldhobbitsLeft		=hl
	-	oldhobbitsRight		=hr
		oldorcsLeft			=ol
	-	oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)

(p testforOldState-valid10
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
	-	oldhobbitsLeft		=hl
		oldhobbitsRight		=hr
	-	oldorcsLeft			=ol
		oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)

(p testforOldState-valid11
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
	-	oldhobbitsLeft		=hl
		oldhobbitsRight		=hr
		oldorcsLeft			=ol
		oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)

(p testforOldState-valid12
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
		oldhobbitsLeft		=hl
	-	oldhobbitsRight		=hr
		oldorcsLeft			=ol
		oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)

(p testforOldState-valid13
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
		oldhobbitsLeft		=hl
		oldhobbitsRight		=hr
	-	oldorcsLeft			=ol
		oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)

(p testforOldState-valid14
	=goal>
		ISA 				state
		currentTask			testforOldState
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
	=imaginal>
		ISA					notagain
		oldhobbitsLeft		=hl
		oldhobbitsRight		=hr
		oldorcsLeft			=ol
	-	oldorcsRight		=or
==>
	=goal>
		currentTask			actualizeWorld
	-imaginal>
)
	
;;
;; we take the imaginary world and put it into the "real" world
;; e.g. we move plannedOrcsLeft to orcsLeft and etc...
;;;

(p actualizeWorld
	=goal>
		ISA   				state
		currentTask   		actualizeWorld
		hobbitsLeft			=hl
		hobbitsRight		=hr
		orcsLeft			=ol
		orcsRight			=or
		plannedLeftHobbits  =newHobbitsLeft
		plannedLeftOrcs     =newOrcsLeft
		plannedRightHobbits =newHobbitsRight
		plannedRightOrcs    =newOrcsRight
		boatLeft            =boatLeft
==>	
	!bind!     =newBoatLeft (mod (+ =boatLeft 1) 2) ;; flip between 0 and 1
	=goal>
       currentTask   		find_new_solution
       hobbitsLeft 			=newHobbitsLeft
       orcsLeft    			=newOrcsLeft
       hobbitsRight  		=newHobbitsRight
       orcsRight     		=newOrcsRight
       boatLeft      		=newBoatLeft
)

;; we create a new mental model of our old world in the imaginary
(p copyWorld
	=goal>
		ISA 			state
		currentTask 	acceptWorld
	=imaginal>
		ISA					notagain
==>
	=goal>
       currentTask   		find_new_solution
)

(goal-focus goal)

(spp transformationOneNull :u 5)
(spp transformationTwoNull :u 10)
(spp transformationOneOne :u 10)
(spp transformationNullOne :u 5)
(spp transformationNullTwo :u 10)
(spp RIGHT_transformationOneNull :u 10)
(spp RIGHT_transformationTwoNull :u 5)
(spp RIGHT_transformationOneOne :u 5)
(spp RIGHT_transformationNullOne :u 10)
(spp RIGHT_transformationNullTwo :u 5)

;(spp anotherAproach :reward 0)
;(spp actualizeWorld :reward 10)
)
