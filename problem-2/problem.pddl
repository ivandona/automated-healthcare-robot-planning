(define (problem healthcare-problem-2)
  (:domain healthcare-delivery)

  ;; OBJECTS
  (:objects
    ;; Locations (unit14 unit 4 at facility 1)
    central-warehouse entrance facility1 facility2 unit11 unit12 unit13 unit14 unit21 unit22 unit23 unit24 - location

    ;; Robots and their carriers
    boxbot1 - mule
    boxbot2 - drone
    patientbot1 - escort-robot

    bb1-carrier bb2-carrier - carrier

    ;; Contents
    scalpel1 scalpel2 - scalpel
    aspirin1 - aspirin
    tongue-depressor1 tongue-depressor2 - tongue-depressor

    ;; Boxes
    box1 box2 box3 box4 box5 - box

    ;; Patients
    alice bob - patient
  )

  ;; INITIAL STATE
  (:init
    ;; Content types
    (is-scalpel scalpel1)
    (is-scalpel scalpel2)
    (is-aspirin aspirin1)
    (is-tongue-depressor tongue-depressor1)
    (is-tongue-depressor tongue-depressor2)

    ;; Connections
    (connected central-warehouse entrance)
    (connected entrance central-warehouse)
    (connected entrance facility1)
    (connected facility1 entrance)

    (connected facility1 unit11)
    (connected facility1 unit12)
    (connected facility1 unit13)
    (connected facility1 unit14)
    (connected unit11 facility1)
    (connected unit12 facility1)
    (connected unit13 facility1)
    (connected unit14 facility1)

    (connected facility2 unit21)
    (connected facility2 unit22)
    (connected facility2 unit23)
    (connected facility2 unit24)
    (connected unit21 facility2)
    (connected unit22 facility2)
    (connected unit23 facility2)
    (connected unit24 facility2)

    (connected facility1 facility2)
    (connected facility2 facility1)

    ;; Robots initial position
    (at boxbot1 central-warehouse)
    (at boxbot2 central-warehouse)
    (at patientbot1 entrance)

    (has-carrier boxbot1 bb1-carrier)
    (has-carrier boxbot2 bb2-carrier)
    (empty-handed patientbot1)

    (at boxbot1 central-warehouse)
    (at boxbot2 central-warehouse)
    (at patientbot1 entrance)

    ;; Carriers
    (= (mule-capacity bb1-carrier) 3)
    (= (drone-capacity bb2-carrier) 1)
    (= (carrier-load bb1-carrier) 0)
    (= (carrier-load bb2-carrier) 0)

    ;; Boxes
    (at box1 central-warehouse)
    (at box2 central-warehouse)
    (at box3 central-warehouse)
    (at box4 central-warehouse)
    (at box5 central-warehouse)
    (empty box1)
    (empty box2)
    (empty box3)
    (empty box4)
    (empty box5)

    ;; Contents
    (at scalpel1 central-warehouse)
    (at scalpel2 central-warehouse)
    (at aspirin1 central-warehouse)
    (at tongue-depressor1 central-warehouse)
    (at tongue-depressor2 central-warehouse)
    
    ;; Patients
    (at alice entrance)
    (at bob entrance)
  )

  ;; GOALS
  (:goal (and
    (at scalpel1 unit11)
    ;(at aspirin1 unit21)
    ;(at tongue-depressor1 unit22)
    ;(at tongue-depressor2 unit22)
    (patient-at-unit alice unit14)
    (patient-at-unit bob unit24)
  ))
)
