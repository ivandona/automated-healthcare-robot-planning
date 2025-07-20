(define (problem healthcare-problem-1)
  (:domain healthcare-delivery-opt)
  (:requirements :strips :typing)

  (:objects
    ;; Locations
    warehouse entrance unit-loc - location

    ;; Robots
    boxbot - robot
    patientbot - robot

    ;; Boxes
    box1 box2 - box

    ;; Contents
    scalpel aspirin - content

    ;; Units
    unit1 unit2 - unit

    ;; Patients
    alice bob - patient
  )

  (:init
    ;; Connectivity
    (connected warehouse unit-loc)
    (connected unit-loc warehouse)
    (connected entrance unit-loc)
    (connected unit-loc entrance)

    ;; Robots and types
    (robot boxbot)
    (carrier-robot boxbot)
    (at-robot boxbot warehouse)

    (robot patientbot)
    (escort-robot patientbot)
    (at-robot patientbot entrance)

    ;; Boxes
    (box box1)
    (box box2)
    (at-box box1 warehouse)
    (at-box box2 warehouse)
    (empty box1)
    (empty box2)

    ;; Contents
    (content scalpel)
    (content aspirin)

    ;; Patients
    (patient alice)
    (patient bob)
    (at-patient alice entrance)
    (at-patient bob entrance)

    ;; Units
    (unit unit1)
    (unit unit2)
    (at-unit unit1 unit-loc)
    (at-unit unit2 unit-loc)
  )

  (:goal (and
    (unit-has unit1 scalpel)
    (unit-has unit2 aspirin)
    (patient-at-unit alice unit1)
    (patient-at-unit bob unit2)
  ))
)
