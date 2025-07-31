(define (domain healthcare-delivery)

  (:requirements :strips :typing)

  (:types
    robot box content location patient - object
    delivery-robot escort-robot - robot
  )

  (:predicates

    ;; --- Location & Connection ---
    (at ?x - object ?l - location)
    (connected ?from - location ?to - location)
    (not-warehouse ?l - location)

    ;; --- Box State ---
    (has-content ?b - box  ?c - content)
    (empty ?b - box)
    
    ;; --- Robot state ---
    (carrying ?r - delivery-robot ?b - box)
    (accompanying ?r - escort-robot ?p - patient)
    (empty-handed ?r - robot)
  )

  ;; --- ACTIONS ---

  ;; Robot Movement
  (:action move
    :parameters (?r - robot ?from - location ?to - location)
    :precondition (and
      (at ?r ?from)
      (connected ?from ?to)
    )
    :effect (and
      (at ?r ?to)
      (not (at ?r ?from))
    )
  )

  ;; Carrying a box
  (:action pickup-box
    :parameters (?r - delivery-robot ?b - box ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?b ?l)
      (empty-handed ?r)
    )
    :effect (and
      (carrying ?r ?b)
      (not (empty-handed ?r))
      (not (at ?b ?l))
    )
  )

  ;; Drop a box
  (:action drop-box
    :parameters (?r - delivery-robot ?b - box ?l - location)
    :precondition (and
      (carrying ?r ?b)
      (at ?r ?l)
    )
    :effect (and
      (at ?b ?l)
      (not (carrying ?r ?b))
      (empty-handed ?r)
    )
  )

  ;; Fill box with content not in the warehouse (limited supply)
  (:action fill-box
    :parameters (?r - delivery-robot ?b - box ?c - content ?l - location)
    :precondition (and 
      (at ?r ?l)
      (at ?b ?l)
      (at ?c ?l)
      (empty ?b)
      (empty-handed ?r)
      (not-warehouse ?l)
    )
    :effect (and 
      (has-content ?b ?c)
      (not (empty ?b))
      (not (at ?c ?l))
    )
  )
  
  ;; Fill box with content in the warehouse (infinite supply)
  (:action fill-box-warehouse
    :parameters (?r - delivery-robot ?b - box ?c - content ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?b ?l)
      (at ?c ?l)
      (empty ?b)
      (empty-handed ?r)
    )
    :effect (and
      (has-content ?b ?c)
      (not (empty ?b))
    )
  )

  ;; Empty box at medical unit
  (:action empty-box
    :parameters (?r - delivery-robot ?b - box ?c - content ?l - location)
    :precondition (and
      (has-content ?b ?c)
      (at ?r ?l)
      (at ?b ?l)
    )
    :effect (and
      (at ?c ?l)
      (empty ?b)
      (not (has-content ?b ?c))
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
