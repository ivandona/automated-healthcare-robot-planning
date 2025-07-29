(define (domain healthcare-delivery)

  (:requirements :strips :typing :numeric-fluents)

  (:types
    robot box content location patient carrier - object
    delivery-robot escort-robot - robot
    drone mule - delivery-robot
    aspirin scalpel tongue-depressor - content
  )

  (:predicates
    ;; --- Location & Connection ---
    (at ?x - object ?l - location)
    (connected ?from - location ?to - location)

    ;; --- Robot state ---
    (accompanying ?r - escort-robot ?p - patient)
    (has-carrier ?r - delivery-robot ?c - carrier)
    (empty-handed ?r - escort-robot)

    ;; --- Carrier state ---
    (has-box ?c - carrier ?b - box)

    ;; --- Box State ---
    (has-content ?b - box  ?c - content)
    (empty ?b - box)
    
    ;; --- Is content of type ... ---
    (is-aspirin ?c - content)
    (is-tongue-depressor ?c - content)
    (is-scalpel ?c - content)

    ;; --- Delivered status (for goals) ---
    (patient-at-unit ?p - patient ?u - location)
  )

  (:functions
    (mule-capacity ?c - carrier)
    (drone-capacity ?c - carrier)
    (carrier-load ?c - carrier)
  )

  ;; --- ACTIONS ---

  ;; Robot Movement
  (:action move
    :parameters (?r - escort-robot ?from - location ?to - location)
    :precondition (and
      (at ?r ?from)
      (connected ?from ?to)
    )
    :effect (and
      (at ?r ?to)
      (not (at ?r ?from))
    )
  )

  (:action move-with-carrier
    :parameters (?r - delivery-robot ?c - carrier ?from - location ?to - location)
    :precondition (and
        (has-carrier ?r ?c)
        (at ?r ?from)
        (at ?c ?from)
        (connected ?from ?to)
    )
    :effect (and
        (not (at ?r ?from)) (at ?r ?to)
        (not (at ?c ?from)) (at ?c ?to)
    )
  )

  (:action move-box-in-carrier
    :parameters (?b - box ?c - carrier ?from - location ?to - location)
    :precondition (and
        (has-box ?c ?b)
        (at ?b ?from)
        (connected ?from ?to)
    )
    :effect (and
        (not (at ?b ?from))
        (at ?b ?to)
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
  (:action pickup-box-with-mule
    :parameters (?r - mule ?c - carrier ?b - box ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?c ?l)
      (at ?b ?l)
      (has-carrier ?r ?c)
      (< (carrier-load ?c) (mule-capacity ?c))
    )
    :effect (and
      (has-box ?c ?b)
      (increase (carrier-load ?c) 1)
    )
  )

  (:action pickup-box-with-drone
    :parameters (?r - drone ?c - carrier ?b - box ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?c ?l)
      (at ?b ?l)
      (has-carrier ?r ?c)
      (< (carrier-load ?c) (drone-capacity ?c))
    )
    :effect (and
      (has-box ?c ?b)
      (increase (carrier-load ?c) 1)
    )
  )

  (:action drop-box
    :parameters (?r - delivery-robot ?c - carrier ?b - box ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?c ?l)
      (at ?b ?l)
      (has-carrier ?r ?c)
      (has-box ?c ?b)
    )
    :effect (and
      (at ?b ?l)
      (not (has-box ?c ?b))
      (decrease (carrier-load ?c) 1)
    )
  )

  ;; Fill box with content
  (:action fill-box
    :parameters (?r - delivery-robot ?c - carrier ?b - box ?ct - content ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?c ?l)
      (at ?ct ?l)
      (at ?b ?l)
      (empty ?b)
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
      (has-carrier ?r ?c)
      (has-box ?c ?b)
      (has-content ?b ?ct)
      (at ?r ?l)
      (at ?c ?l)
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
      (patient-at-unit ?p ?l)
      (not (accompanying ?r ?p))
      (empty-handed ?r)
    )
  )
)
