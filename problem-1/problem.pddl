(define (problem healthcare-problem-1)
  (:domain healthcare-delivery)

  ;; OBJECTS
  (:objects
    ;; Locations
    warehouse entrance unit-loc - location

    ;; Robots
    boxbot - robot
    patientbot - robot

    ;; Robots by role
    ;; Note: roles defined by predicates, not types
    ;; Contents
    scalpel aspirin - content

    ;; Boxes
    box1 box2 - box

    ;; Units
    unit1 unit2 - unit

    ;; Patients
    alice bob - patient
  )

  ;; INITIAL STATE
  (:init
    ;; Locations
    (location warehouse)
    (location entrance)
    (location unit-loc)

    ;; Connections
    (connected warehouse unit-loc)
    (connected unit-loc warehouse)
    (connected entrance unit-loc)
    (connected unit-loc entrance)

    ;; Robots and roles
    (robot boxbot)
    (carrier-robot boxbot)
    (at boxbot warehouse)

    (robot patientbot)
    (escort-robot patientbot)
    (at patientbot entrance)

    ;; Boxes
    (box box1)
    (box box2)
    (at box1 warehouse)
    (at box2 warehouse)
    (empty box1)
    (empty box2)

    ;; Contents (all at warehouse — assumed available for filling)
    (content scalpel)
    (content aspirin)

    ;; Patients
    (patient alice)
    (at alice entrance)

    (patient bob)
    (at bob entrance)

    ;; Units and their location
    (unit unit1)
    (unit unit2)
    (at-unit unit1 unit-loc)
    (at-unit unit2 unit-loc)
  )

  ;; GOALS
  (:goal (and
    ;; Supplies delivered
    (unit-has unit1 scalpel)
    (unit-has unit2 aspirin)

    ;; Patients escorted
    (patient-at-unit alice unit1)
    (patient-at-unit bob unit2)
  ))
)
