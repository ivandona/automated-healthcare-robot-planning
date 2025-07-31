(define (problem healthcare-problem-2)
  (:domain healthcare-delivery)

  ;; OBJECTS
  (:objects
    ;; Locations (unit14 unit 4 at facility 1)
    central-warehouse entrance facility1 facility2 unit11 unit12 unit13 unit14 unit21 unit22 unit23 unit24 - location

    ;; Robots and their carriers
    boxbot1 - delivery-robot
    patientbot1 - escort-robot

    bb1-carrier - carrier

    ;; Contents
    scalpel tongue-depressor aspirin - content

    ;; Boxes
    box1 box2 box3 box4 box5 - box

    ;; Patients
    alice bob - patient
  )

  ;; INITIAL STATE
  (:init
    (not-warehouse entrance)
    (not-warehouse facility1)
    (not-warehouse facility2)
    (not-warehouse unit11)
    (not-warehouse unit12)
    (not-warehouse unit13)
    (not-warehouse unit14)
    (not-warehouse unit21)
    (not-warehouse unit22)
    (not-warehouse unit23)
    (not-warehouse unit24)
    
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

    ;; Robots initial state
    (at boxbot1 central-warehouse)
    (at patientbot1 entrance)
    (has-carrier boxbot1 bb1-carrier)
    (empty-handed patientbot1)

    ;; Carriers
    ;(at bb1-carrier central-warehouse)
    (not-loaded bb1-carrier box1)
    (not-loaded bb1-carrier box2)
    (not-loaded bb1-carrier box3)
    (not-loaded bb1-carrier box4)
    (not-loaded bb1-carrier box5)

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
    (at scalpel central-warehouse)
    (at aspirin central-warehouse)
    (at tongue-depressor central-warehouse)
    
    ;; Patients
    (at alice entrance)
    (at bob entrance)

    (= (carrier-capacity bb1-carrier) 3)
    (= (carrier-load bb1-carrier) 0)
  )

  ;; GOALS
  (:goal (and
    (at scalpel unit11)
    (at aspirin unit21)
    (at tongue-depressor unit21)
    (at tongue-depressor unit24)
    (at alice unit14)
    (at bob unit24)
  ))
)
