
(clear-all)
(define-model env-model
(sgp :esc t :lf .05 :ans 0.25 :trace-detail high)

(setf *old* 1)

(chunk-type state currentTask hobbitsLeft orcsLeft boatLeft plannedLeftHobbits plannedLeftOrcs moveHobbits moveOrcs hobbitsAreSafe)
(chunk-type task taskLeft taskRight hobbitsMove orcsMove boatMove)
(chunk-type waypoint step hobbitsLeft orcsLeft )
(chunk-type evaluateOptions target)



(add-dm
 (findTask ISA chunk)
 (nobodyShouldGetEaten ISA chunk)
 (checkMovementForValidity ISA chunk)
 (selectTaskLeft ISA chunk)
 (selectTaskRight ISA chunk)

 
 (goal ISA state currentTask start hobbitsLeft 3 orcsLeft 3 boatLeft 1 moveOrcs 0 moveHobbits 0 )
 )

;; Start looking for a task (taskLeft) that transfers orcs and hobbits from left to right.
;; We assume that the boat ist on the left side with boatLeft = 1
;;
(p checkAbbruchbedingung
  !eval! (print 'check-abbruch)
 =goal>
  ISA     state
  currentTask   start
  hobbitsLeft   =h
  orcsLeft    =o
  !eval! (print  (concatenate 'string (write-to-string =h) " H " (write-to-string =o) " O") )
==>
 =goal>
  currentTask   findTask
)



(p transformationOneNull
  =>goal>
    ISA state
    currentTask findTask
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
    >= orcsLeft 2
==>
  =goal>
    currentTask   validateMove
    moveHobbits   0
    moveOrcs      2
  )



(p setImaginaryWorld
  =goal>
    ISA   state
    currentTask validateMove
    moveHobbits =movedHobbits
    moveOrcs    =movedOrcs
    orcsLeft    =oldOrcsLeft 
    hobbitsLeft =oldHobbitsLeft
==>  
  !bind!     =newHobbitsLeft (+ =movedHobbits =oldOrcsLeft)
  !bind!     =newOrcsLeft (+ =movedHobbits =oldHobbitsLeft)
  =goal>
    currentTask         eatHobbits
    plannedLeftHobbits  =newHobbitsLeft
    plannedLeftOrcs     =newOrcsLeft
)



;; 
(p areHobbitsSafe1_0
  =goal>
    ISA   state
    currentTask   eatHobbits
    plannedLeftHobbits 0
==>
  =goal>
    currentTask eatHobbits2
    hobbitsAreEaten 0
  )

;; 
(p areHobbitsSafe1_1
  =goal>
    ISA   state
    currentTask   eatHobbits2
    plannedLeftHobbits 0
==>
  !bind!     =moveValue (+ =movedHobbits =oldHobbitsLeft)
  =goal>
    currentTask eatHobbits2
    hobbitsAreEaten 0
  )





(goal-focus goal)
)