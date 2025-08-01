(define (domain healthcare-delivery)

  (:requirements :strips :typing :numeric-fluents)

  (:types
    robot box content location patient carrier - object
    delivery-robot escort-robot - robot
    drone - delivery-robot
  )

  (:predicates
    ;; --- Location & Connection ---
    (at ?x - object ?l - location)
    (connected ?from - location ?to - location)
    (not-warehouse ?l - location)
    (has-window ?l - location) ; for drone

    ;; --- Robot state ---
    (accompanying ?r - escort-robot ?p - patient)
    (has-carrier ?r - delivery-robot ?c - carrier)
    (empty-handed ?r - escort-robot)
    (not-drone ?r - robot)

    ;; --- Carrier state ---
    (has-box ?c - carrier ?b - box)
    (not-loaded ?c - carrier ?b - box)

    ;; --- Box State ---
    (has-content ?b - box  ?c - content)
    (empty ?b - box)
    
  )

  (:functions
    (carrier-capacity ?c - carrier) ; carrier max capacity
    (carrier-load ?c - carrier) ; carrier current nr of boxes loaded
  )

  ;; --- ACTIONS ---

  ;; Robot Movement
  (:action move
    :parameters (?r - robot ?from - location ?to - location)
    :precondition (and
      (at ?r ?from)
      (connected ?from ?to)
      (not-drone ?r)
    )
    :effect (and
      (at ?r ?to)
      (not (at ?r ?from))
    )
  )

  ;; Drone can move between any places that have windows
  (:action move_drone
    :parameters (?r - drone ?from - location ?to - location)
    :precondition (and 
      (at ?r ?from)
      (has-window ?from)
      (has-window ?to)
    )
    :effect (and 
      (at ?r ?to)
      (not (at ?r ?from))
    )
  )
  

  ;; Loading a box in the carrier
  (:action pickup-box
    :parameters (?r - delivery-robot ?c - carrier ?b - box ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?b ?l)
      (not-loaded ?c ?b)
      (has-carrier ?r ?c)
      (< (carrier-load ?c) (carrier-capacity ?c))
    )
    :effect (and
      (has-box ?c ?b)
      (not (at ?b ?l))
      (not (not-loaded ?c ?b))
      (increase (carrier-load ?c) 1)
    )
  )

  (:action drop-box
    :parameters (?r - delivery-robot ?c - carrier ?b - box ?l - location)
    :precondition (and
      (at ?r ?l)
      (has-carrier ?r ?c)
      (has-box ?c ?b)
    )
    :effect (and
      (at ?b ?l)
      (not-loaded ?c ?b)
      (not (has-box ?c ?b))
      (decrease (carrier-load ?c) 1)
    )
  )

  ;; Fill box with content not in the warehouse (limited supply)
  (:action fill-box
    :parameters (?r - delivery-robot ?c - carrier ?b - box ?ct - content ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?b ?l)
      (at ?ct ?l)
      (empty ?b)
      (not-loaded ?c ?b)
      (not-warehouse ?l)
    )
    :effect (and
      (has-content ?b ?ct)
      (not (empty ?b))
      (not (at ?ct ?l))
    )
  )

  ;; Fill box with content in the warehouse (infinite supply)
  (:action fill-box-warehouse
    :parameters (?r - delivery-robot ?c - carrier ?b - box ?ct - content ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?b ?l)
      (at ?ct ?l)
      (empty ?b)
      (not-loaded ?c ?b)
    )
    :effect (and
      (has-content ?b ?ct)
      (not (empty ?b))
    )
  )

  ;; Empty box at medical unit
  (:action empty-box
    :parameters (?r - delivery-robot ?c - carrier ?b - box ?ct - content ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?b ?l)
      (has-carrier ?r ?c)
      (has-content ?b ?ct)
    )
    :effect (and
      (at ?ct ?l)
      (empty ?b)
      (not (has-content ?b ?ct))
    )
  )

  ;; Escorting patients
  (:action pickup-patient
    :parameters (?r - escort-robot ?p - patient ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?p ?l)
      (empty-handed ?r)
    )
    :effect (and
      (accompanying ?r ?p)
      (not (empty-handed ?r))
    )
  )

  (:action drop-patient
    :parameters (?r - escort-robot ?p - patient ?l - location)
    :precondition (and
      (accompanying ?r ?p)
      (at ?r ?l)
    )
    :effect (and
      (at ?p ?l)
      (not (accompanying ?r ?p))
      (empty-handed ?r)
    )
  )
)
