(define (domain healthcare-delivery-opt)
  (:requirements :strips :typing)

  (:types
    location robot box content unit patient
  )

  (:predicates
    ;; Type membership
    (location ?l - location)
    (robot ?r - robot)
    (box ?b - box)
    (content ?c - content)
    (unit ?u - unit)
    (patient ?p - patient)

    ;; Robot roles
    (carrier-robot ?r - robot)
    (escort-robot ?r - robot)

    ;; Locations
    (connected ?from - location ?to - location)
    (at-robot ?r - robot ?l - location)
    (at-box ?b - box ?l - location)
    (at-patient ?p - patient ?l - location)
    (at-unit ?u - unit ?l - location)

    ;; Box state
    (empty ?b - box)
    (contains ?b - box ?c - content)

    ;; Carried by robot
    (loaded ?r - robot ?b - box)
    (is-loaded ?r - robot)

    ;; Escorted by robot
    (accompanying ?r - robot ?p - patient)
    (is-escorting ?r - robot)

    ;; Unit has received content
    (unit-has ?u - unit ?c - content)

    ;; Patient goal
    (patient-at-unit ?p - patient ?u - unit)
  )

  ;; Robot moves alone
  (:action move
    :parameters (?r - robot ?from - location ?to - location)
    :precondition (and
      (at-robot ?r ?from)
      (connected ?from ?to)
    )
    :effect (and
      (not (at-robot ?r ?from))
      (at-robot ?r ?to)
    )
  )

  ;; Pick up a box (only if not already loaded)
  (:action pick-up-box
    :parameters (?r - robot ?b - box ?l - location)
    :precondition (and
      (carrier-robot ?r)
      (at-robot ?r ?l)
      (at-box ?b ?l)
    )
    :effect (and
      (not (at-box ?b ?l))
      (loaded ?r ?b)
      (is-loaded ?r)
    )
  )

  ;; Deliver box to a unit (drop at location)
  (:action deliver-box
    :parameters (?r - robot ?b - box ?u - unit ?l - location)
    :precondition (and
      (carrier-robot ?r)
      (loaded ?r ?b)
      (at-robot ?r ?l)
      (at-unit ?u ?l)
    )
    :effect (and
      (not (loaded ?r ?b))
      (not (is-loaded ?r))
      (at-box ?b ?l)
    )
  )

  ;; Fill box with content
  (:action fill-box
    :parameters (?r - robot ?b - box ?c - content ?l - location)
    :precondition (and
      (carrier-robot ?r)
      (at-robot ?r ?l)
      (at-box ?b ?l)
      (empty ?b)
      (content ?c)
    )
    :effect (and
      (not (empty ?b))
      (contains ?b ?c)
    )
  )

  ;; Unload box and give content to unit
  (:action unload-box
    :parameters (?r - robot ?b - box ?u - unit ?c - content ?l - location)
    :precondition (and
      (carrier-robot ?r)
      (contains ?b ?c)
      (at-box ?b ?l)
      (at-unit ?u ?l)
    )
    :effect (and
      (not (contains ?b ?c))
      (empty ?b)
      (unit-has ?u ?c)
    )
  )

  ;; Escort a patient (single step)
  (:action escort-patient
    :parameters (?r - robot ?p - patient ?from - location ?to - location ?u - unit)
    :precondition (and
      (escort-robot ?r)
      (at-robot ?r ?from)
      (at-patient ?p ?from)
      (connected ?from ?to)
      (at-unit ?u ?to)
    )
    :effect (and
      (not (at-robot ?r ?from))
      (not (at-patient ?p ?from))
      (at-robot ?r ?to)
      (at-patient ?p ?to)
      (patient-at-unit ?p ?u)
      (is-escorting ?r)
    )
  )
)
