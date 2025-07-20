(define (domain healthcare-delivery)

  (:requirements :strips)

  ;; --- TYPE PREDICATES ---
  (:predicates
    (robot ?r)
    (carrier-robot ?r)
    (escort-robot ?r)
    (box ?b)
    (content ?c)
    (patient ?p)
    (unit ?u)
    (location ?l)

    ;; --- Location & Connection ---
    (at ?x ?l) ; for robots, boxes, patients
    (connected ?from ?to)

    ;; --- Box State ---
    (has-content ?b ?c)
    (empty ?b)
    (carrying ?r ?b)

    ;; --- Escorting Patients ---
    (accompanying ?r ?p)

    ;; --- Unit Associations & Inventory ---
    (at-unit ?u ?l)
    (unit-has ?u ?c)

    ;; --- Delivered status (for goals) ---
    (patient-at-unit ?p ?u)
  )

  ;; --- ACTIONS ---

  ;; Robot Movement
  (:action move
    :parameters (?r ?from ?to)
    :precondition (and
      (robot ?r)
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
    :parameters (?r ?b ?l)
    :precondition (and
      (carrier-robot ?r)
      (box ?b)
      (at ?r ?l)
      (at ?b ?l)
    )
    :effect (and
      (carrying ?r ?b)
      (not (at ?b ?l))
    )
  )

  (:action drop-box
    :parameters (?r ?b ?l)
    :precondition (and
      (carrier-robot ?r)
      (carrying ?r ?b)
      (at ?r ?l)
    )
    :effect (and
      (at ?b ?l)
      (not (carrying ?r ?b))
    )
  )

  ;; Fill box with content
  (:action fill-box
    :parameters (?r ?b ?c ?l)
    :precondition (and
      (carrier-robot ?r)
      (box ?b)
      (content ?c)
      (at ?r ?l)
      (at ?b ?l)
      (empty ?b)
    )
    :effect (and
      (has-content ?b ?c)
      (not (empty ?b))
    )
  )

  ;; Empty box at medical unit
  (:action empty-box
    :parameters (?r ?b ?c ?u ?l)
    :precondition (and
      (carrier-robot ?r)
      (carrying ?r ?b)
      (has-content ?b ?c)
      (at ?r ?l)
      (at-unit ?u ?l)
    )
    :effect (and
      (unit-has ?u ?c)
      (empty ?b)
      (not (has-content ?b ?c))
    )
  )

  ;; Deliver full box to medical unit (without unpacking)
  (:action deliver-box
    :parameters (?r ?b ?u ?l)
    :precondition (and
      (carrier-robot ?r)
      (carrying ?r ?b)
      (at ?r ?l)
      (at-unit ?u ?l)
    )
    :effect (and
      (at ?b ?l)
      (not (carrying ?r ?b))
    )
  )

  ;; Escorting patients
  (:action pickup-patient
    :parameters (?r ?p ?l)
    :precondition (and
      (escort-robot ?r)
      (patient ?p)
      (at ?r ?l)
      (at ?p ?l)
    )
    :effect (and
      (accompanying ?r ?p)
      (not (at ?p ?l))
    )
  )

  (:action drop-patient
    :parameters (?r ?p ?u ?l)
    :precondition (and
      (escort-robot ?r)
      (accompanying ?r ?p)
      (at ?r ?l)
      (at-unit ?u ?l)
    )
    :effect (and
      (patient-at-unit ?p ?u)
      (not (accompanying ?r ?p))
    )
  )
)
