

(clear-all)
(define-model env-model
(sgp :esc t :lf .05  :ans 0.55 :ul T  :trace-detail high :ult T)

(setf *old* 1)

(chunk-type state currentTask hobbitsLeft hobbitsRight orcsLeft orcsRight boatLeft plannedLeftHobbits plannedRightHobbits plannedLeftOrcs plannedRightOrcs moveHobbits moveOrcs )




(add-dm
 (findTask ISA chunk)
 (start ISA chunk)
 (validateMove ISA chunk)
 (checkLeftSide ISA chunk)
 (checkRightSide ISA chunk)

 (goal ISA state currentTask start hobbitsLeft 3 orcsLeft 3 hobbitsRight 0 orcsRight 0  boatLeft 1 moveOrcs 0 moveHobbits 0 )
 )

;; Start looking for a task (taskLeft) that transfers orcs and hobbits from left to right.
;; We assume that the boat ist on the left side with boatLeft = 1
;;
(p checkAbbruchbedingung
;; !eval! (print 'check-abbruch)
 =goal>
  ISA     state
  currentTask   start
  hobbitsLeft   =h
  orcsLeft    =o
  boatLeft    =b
  !eval! (print  (concatenate 'string (write-to-string =h) (write-to-string =o) (write-to-string =b)) )
==>
 =goal>
  currentTask   findTask
)

;;
(p FINISH
  ;;!eval! (print 'check-abbruch)
 =goal>
  ISA     state
  currentTask   start
  hobbitsLeft   0
  orcsLeft      0
  boatLeft      0
==>
 =goal>
  currentTask   nil
)

(p anotherAproach
  =goal>
    ISA state
    currentTask find_new_solution
==>
  =goal>
    currentTask findTask
  )



;;
;; Transformations for the left side of the river
;;;

(p transformationOneNull
  =goal>
    ISA state
    currentTask findTask
    boatLeft 1
    >= hobbitsLeft 1
==>
  =goal>
    currentTask   validateMove
    moveHobbits   1
    moveOrcs      0
  )


(p transformationTwoNull
  =goal>
    ISA state
    currentTask findTask
    boatLeft 1
    >= hobbitsLeft 2
==>
  =goal>
    currentTask   validateMove
    moveHobbits   2
    moveOrcs      0
  )


(p transformationOneOne
  =goal>
    ISA state
    currentTask findTask
    boatLeft 1
    >= hobbitsLeft 1
    >= orcsLeft 1
==>
  =goal>
    currentTask   validateMove
    moveHobbits   1
    moveOrcs      1
  )


(p transformationNullOne
  =goal>
    ISA state
    currentTask findTask
    boatLeft 1
    >= orcsLeft 1
==>
  =goal>
    currentTask   validateMove
    moveHobbits   0
    moveOrcs      1
  )


(p transformationNullTwo
  =goal>
    ISA state
    currentTask findTask
    boatLeft 1
    >= orcsLeft 2
==>
  =goal>
    currentTask   validateMove
    moveHobbits   0
    moveOrcs      2
  )


;;
;; Transformations for the RIGHT side of the river
;;;




(p RIGHT_transformationOneNull
  =goal>
    ISA state
    currentTask findTask
    boatLeft 0
    >= hobbitsRight 1
==>
  =goal>
    currentTask   validateMove
    moveHobbits   -1
    moveOrcs      0
  )


(p RIGHT_transformationTwoNull
  =goal>
    ISA state
    currentTask findTask
    boatLeft 0
    >= hobbitsRight 2
==>
  =goal>
    currentTask   validateMove
    moveHobbits   -2
    moveOrcs      0
  )


(p RIGHT_transformationOneOne
  =goal>
    ISA state
    currentTask findTask
    boatLeft 0
    >= hobbitsRight 1
    >= orcsRight 1
==>
  =goal>
    currentTask   validateMove
    moveHobbits   -1
    moveOrcs      -1
  )


(p RIGHT_transformationNullOne
  =goal>
    ISA state
    currentTask findTask
    boatLeft 0
    >= orcsRight 1
==>
  =goal>
    currentTask   validateMove
    moveHobbits   0
    moveOrcs      -1
  )


(p RIGHT_transformationNullTwo
  =goal>
    ISA state
    currentTask findTask
    boatLeft 0
    >= orcsRight 2
==>
  =goal>
    currentTask   validateMove
    moveHobbits   0
    moveOrcs      -2
  )


;;
;; SET our "planned" world state - so we can evaluate the anticipated turn
;;;

(p setImaginaryWorld
  =goal>
    ISA   state
    currentTask validateMove
    moveHobbits =movedHobbits
    moveOrcs    =movedOrcs
    orcsLeft    =oldOrcsLeft
    orcsRight   =oldOrcsRight
    hobbitsLeft =oldHobbitsLeft
    hobbitsRight =oldHobbitsRight
==>
  !bind!     =newHobbitsLeft (- =oldHobbitsLeft =movedHobbits)
  !bind!     =newOrcsLeft (- =oldOrcsLeft =movedOrcs)
  !bind!     =newHobbitsRight (+ =oldOrcsRight =movedHobbits)
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
  ISA     state
  currentTask   checkLeftSide
  plannedLeftHobbits    1
  > plannedLeftOrcs     1
==>
 =goal>
  currentTask find_new_solution
)


(p LEFT_moveIsInValid_HobbitsGetEaten2
 ;; !eval! (print 'invalid-move-HOBBITSareDEAD)
 =goal>
  ISA     state
  currentTask   checkLeftSide
  plannedLeftHobbits    2
  > plannedLeftOrcs   2
==>
 =goal>
  currentTask find_new_solution
)


(p LEFT_moveIsValid_NO-HobbitsGetEaten1
 ;; !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
 =goal>
  ISA     state
  currentTask   checkLeftSide
  plannedLeftHobbits    1
  <= plannedLeftOrcs   1
==>
 =goal>
  currentTask checkRightSide
)

(p LEFT_moveIsValid_NO-HobbitsGetEaten2
;;  !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
 =goal>
  ISA     state
  currentTask   checkLeftSide
  plannedLeftHobbits    2
  <= plannedLeftOrcs   2
==>
 =goal>
  currentTask checkRightSide
)

(p LEFT_moveIsValid_NO-HobbitsGetEaten3
;;  !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
 =goal>
  ISA     state
  currentTask   checkLeftSide
  plannedLeftHobbits    3
==>
 =goal>
  currentTask checkRightSide
)


(p LEFT_moveIsValid_NO-HobbitsGetEaten4
;;  !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
 =goal>
  ISA     state
  currentTask   checkLeftSide
  plannedLeftHobbits    0
==>
 =goal>
  currentTask checkRightSide
)


;;
;; CHECK RIGHT SIDE
;;;

(p RIGHT_moveIsInValid_HobbitsGetEaten1
;;  !eval! (print 'invalid-move-HOBBITSareDEAD)
 =goal>
  ISA     state
  currentTask   checkRightSide
  plannedRightHobbits    1
  > plannedRightOrcs     1
==>
 =goal>
  currentTask find_new_solution
)


(p RIGHT_moveIsInValid_HobbitsGetEaten2
;;  !eval! (print 'invalid-move-HOBBITSareDEAD)
 =goal>
  ISA     state
  currentTask   checkRightSide
  plannedRightHobbits    2
  > plannedRightOrcs   2
==>
 =goal>
  currentTask find_new_solution
)


(p RIGHT_moveIsValid_NO-HobbitsGetEaten1
;;  !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
 =goal>
  ISA     state
  currentTask   checkRightSide
  plannedRightHobbits    1
  <= plannedRightOrcs   1
==>
 =goal>
  currentTask actualizeWorld
)

(p RIGHT_moveIsValid_NO-HobbitsGetEaten2
 ;; !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
 =goal>
  ISA     state
  currentTask   checkRightSide
  plannedRightHobbits    2
  <= plannedRightOrcs   2
==>
 =goal>
  currentTask actualizeWorld
)

(p RIGHT_moveIsValid_NO-HobbitsGetEaten3
;;  !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
 =goal>
  ISA     state
  currentTask   checkRightSide
  plannedRightHobbits    3
==>
 =goal>
  currentTask actualizeWorld
)

(p RIGHT_moveIsValid_NO-HobbitsGetEaten4
;;  !eval! (print 'valid-move-HOBBITSare-NOT-DEAD)
 =goal>
  ISA     state
  currentTask   checkRightSide
  plannedRightHobbits    0
==>
 =goal>
  currentTask actualizeWorld
)

;;
;; we take the imaginary world and put it into the "real" world
;; e.g. we move plannedOrcsLeft to orcsLeft and etc...
;;;

(p actualizeWorld
  =goal>
    ISA   state
    currentTask   actualizeWorld
    plannedLeftHobbits  =newHobbitsLeft
    plannedLeftOrcs     =newOrcsLeft
    plannedRightHobbits =newHobbitsRight
    plannedRightOrcs    =newOrcsRight
    boatLeft            =boatLeft
  ==>
    !bind!     =newBoatLeft (mod (+ =boatLeft 1) 2) ;; flip between 0 and 1
    =goal>
      currentTask   start
      hobbitsLeft =newHobbitsLeft
      orcsLeft    =newOrcsLeft
      hobbitsRight  =newHobbitsRight
      orcsRight     =newOrcsRight
      boatLeft      =newBoatLeft

  )

(goal-focus goal)

(spp anotherAproach :reward 0)
(spp actualizeWorld :reward 0)
)


