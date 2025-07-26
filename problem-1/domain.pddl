(define (domain healthcare-delivery)

  (:requirements :strips :typing)

  (:types
    robot box content location patient - object
    carrier-robot escort-robot - robot
    aspirin scalpel tongue-depressor - content
  )

  (:predicates
    ;; --- Is content of type ... ---
    (is-aspirin ?c - content)
    (is-tongue-depressor ?c - content)
    (is-scalpel ?c - content)

    ;; --- Location & Connection ---
    (at ?x - object ?l - location)
    (connected ?from - location ?to - location)

    ;; --- Box State ---
    (has-content ?b - box  ?c - content)
    (empty ?b - box)
    (carrying ?r - carrier-robot ?b - box)
    
    ;; --- Escorting Patients ---
    (accompanying ?r - escort-robot ?p - patient)

    (empty-handed ?r - robot)

    ;; --- Delivered status (for goals) ---
    (patient-at-unit ?p - patient ?u - location)
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

  (:action move-with-box
    :parameters (?r - carrier-robot ?b - box ?from - location ?to - location)
    :precondition (and
      (at ?r ?from)
      (at ?b ?from)
      (connected ?from ?to)
      (carrying ?r ?b)
    )
    :effect (and
      (at ?r ?to)
      (not (at ?r ?from))
      (at ?b ?to)
      (not (at ?b ?from))
    )
  )

  (:action move-with-patient
    :parameters (?r - escort-robot ?p - patient ?from - location ?to - location)
    :precondition (and
      (at ?r ?from)
      (at ?p ?from)
      (connected ?from ?to)
      (accompanying ?r ?p)
    )
    :effect (and
      (at ?r ?to)
      (not (at ?r ?from))
      (at ?p ?to)
      (not (at ?p ?from))
    )
  )

  ;; Carrying a box
  (:action pickup-box
    :parameters (?r - carrier-robot ?b - box ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?b ?l)
      (empty-handed ?r)
    )
    :effect (and
      (carrying ?r ?b)
      (not (empty-handed ?r))
    )
  )

  (:action drop-box
    :parameters (?r - carrier-robot ?b - box ?l - location)
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

  ;; Fill box with content
  (:action fill-box
    :parameters (?r - carrier-robot ?b - box ?c - content ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?b ?l)
      (at ?c ?l)
      (empty ?b)
    )
    :effect (and
      (has-content ?b ?c)
      (not (empty ?b))
    )
  )

  ;; Empty box at medical unit
  (:action empty-box
    :parameters (?r - carrier-robot ?b - box ?c - content ?u - location)
    :precondition (and
      (carrying ?r ?b)
      (has-content ?b ?c)
      (at ?r ?u)
    )
    :effect (and
      (at ?c ?u)
      (empty ?b)
      (not (has-content ?b ?c))
    )
  )

  ;; Deliver full box to medical unit (without unpacking)
  (:action deliver-box
    :parameters (?r - carrier-robot ?b - box ?u - location)
    :precondition (and
      (carrying ?r ?b)
      (at ?r ?u)
    )
    :effect (and
      (at ?b ?u)
      (not (carrying ?r ?b))
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
    :parameters (?r - escort-robot ?p - patient ?u - location)
    :precondition (and
      (accompanying ?r ?p)
      (at ?r ?u)
    )
    :effect (and
      (patient-at-unit ?p ?u)
      (not (accompanying ?r ?p))
      (empty-handed ?r)
    )
  )
)
