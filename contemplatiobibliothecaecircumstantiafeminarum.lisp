
(clear-all)
  
· Grundsätzliche Übersetzung:
mögliche zustände apriori ins dm -> nein. unplausibel.
mögliche Züge ins dm -> plausibel? oder wird auch das erst per dm erinnert. pro: es gibt Instruktionen. contra: die Leute machen Fehler = nicht gut antizipierend.
tabula rasa im dm und trial & error und dann erst merken im dm. dafür bräuchte man einen zufallsgenerator für erste züge oder was?

· Interne Heuristik:  A mehr rechts = besser. aktivation.
                      B trial & error.
· Moves. 

; ->
(megamoveright1 isa move 1h1o) bekommt mehr aktivation (wie?)
(megamoveright2 2h0o) bekommt mehr aktivation
(megamoveright3 0h2o) bekommt mehr aktivation
(minormoveright1 1h0o) bekommt weniger aktivation
(minormoveright2 0h1o) bekommt weniger aktivation

; <-
(megamoveleft1 1h1o) bekommt weniger aktivation
(megamoveleft2 2h0o) bekommt weniger aktivation
(megamoveleft3 0h2o) bekommt weniger aktivation
(minormoveleft1 1h0o) bekommt mehr aktivation
(minormoveleft2 0h1o) bekommt mehr aktivation

· rewards für gute Züge - wie? Utilities, gefeuerte Produktionen werden verstärkt.

· um Buffer jamming zu vermeiden, immer den modulstatus überprüfen.

· Brauchen wir das imiginary Modul? vorstellen von möglichen Konstellationen.


·Parameter, die wir brauchen
  
  Noise. :ans
  activation der chunks. ?
  Utility. :ul
  Base level learning :bll ≠nil
  spreading activation :mas 



(chunktype state_2_0 H_L O_L B_L; fehlt noch) ;hob left orks left boat left
(chunk-type state currentTask hobbitsLeft orcsLeft boatLeft plannedLeftHobbits plannedLeftOrcs noBodyIsEatenLeft noBodyIsEatenRight)


(add-dm
 (Goal ISA state currentTask nil hobbitsLeft 3 orcsLeft 3 boatLeft 1)
 )

(p Abbruchbedingung
=goal>
  isa state
  currentTask pending
  hobbitsLeft 0
  orcsLeft    0
  boatLeft    0
==>
=goal>
 CurrentTask done
)

(p ImagineAfterPerceiving       ;soll den aktuellen zustand vorstellen, muss noch erweitert werden. nach dem imaginieren folgt das auswählen einer aktion
=goal>  
  isa state
  CurrentTask imagine
  hobbitsLeft =HL
  orcsLeft =OL
  boatLeft =BL
==>
+imaginal>
isa state
  hobbitsLeft =HL
  orcsLeft =OL
  boatLeft =BL
=>goal>
currentTask planMove  
)

(p ChooseAmove
=goal>
  isa state
  currentTask planMove
=imaginal>
isa state
+goal>
isa move
)

                            ;current move: read the fkn act-r tutorial.
(goal-focus goal)
)