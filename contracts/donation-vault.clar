;; title: donation-vault
;; version:
;; summary:
;; description:

;; traits
;;

;; token definitions
;;

;; constants
;;

;; data vars
;;

;; data maps
;;

;; public functions
;;

;; read only functions
;;

;; private functions
;;

;; ---------------------------------------------------
;; Donation Vault - Fully Functional STX Donation Contract
;; ---------------------------------------------------
;; Author: [Your GitHub Username]
;; Description:
;; A simple and secure STX donation vault built with Clarity for the Stacks blockchain.
;; Users can donate STX to a shared vault. The owner can withdraw, transfer ownership,
;; view totals, and manage donation records.
;; ---------------------------------------------------

;; ---------------------------------------------
;; DATA VARIABLES
;; ---------------------------------------------

(define-data-var total-donations uint u0)
(define-data-var owner principal tx-sender)

;; Fixed map definition syntax from ((user principal)) ((amount uint)) to {user: principal} {amount: uint}
(define-map donors {user: principal} {amount: uint})

;; ---------------------------------------------
;; CONSTANTS
;; ---------------------------------------------

(define-constant ERR-NOT-OWNER (err u100))
(define-constant ERR-NO-DONATION (err u101))
(define-constant ERR-INVALID-AMOUNT (err u102))
(define-constant ERR-NO-FUNDS (err u103))

;; ---------------------------------------------
;; USER FUNCTIONS
;; ---------------------------------------------

;; Allows a user to donate STX to the contract
(define-public (donate (amount uint))
  (begin
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))

    (let ((prev (default-to u0 (get amount (map-get? donors { user: tx-sender })))))
      (map-set donors { user: tx-sender } { amount: (+ prev amount) })
      (var-set total-donations (+ (var-get total-donations) amount))
      (ok { donor: tx-sender, donated: amount, total: (var-get total-donations) })
    )
  )
)

;; ---------------------------------------------
;; OWNER FUNCTIONS
;; ---------------------------------------------

;; Owner withdraws STX from vault
(define-public (withdraw (amount uint))
  (begin
    (asserts! (is-eq tx-sender (var-get owner)) ERR-NOT-OWNER)
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (asserts! (>= (var-get total-donations) amount) ERR-NO-FUNDS)

    (try! (stx-transfer? amount (as-contract tx-sender) tx-sender))
    (var-set total-donations (- (var-get total-donations) amount))
    (ok { withdrawn: amount, remaining: (var-get total-donations) })
  )
)

;; Transfer contract ownership
(define-public (transfer-ownership (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get owner)) ERR-NOT-OWNER)
    (var-set owner new-owner)
    (ok { new-owner: new-owner })
  )
)

;; Reset donor record (for testing or maintenance)
(define-public (reset-donor (user principal))
  (begin
    (asserts! (is-eq tx-sender (var-get owner)) ERR-NOT-OWNER)
    (let ((donation (default-to u0 (get amount (map-get? donors { user: user })))))
      (if (> donation u0)
          (begin
            (map-delete donors { user: user })
            (var-set total-donations (- (var-get total-donations) donation))
            (ok { reset: user, refunded: donation })
          )
          ERR-NO-DONATION
      )
    )
  )
)

;; ---------------------------------------------
;; READ-ONLY FUNCTIONS
;; ---------------------------------------------

;; Get total donations in the vault
(define-read-only (get-total-donations)
  (ok (var-get total-donations))
)

;; Get total donation amount by a user
(define-read-only (get-donor (user principal))
  (ok (default-to u0 (get amount (map-get? donors { user: user }))))
)

;; Get current contract owner
(define-read-only (get-owner)
  (ok (var-get owner))
)

;; ---------------------------------------------
;; ADMIN READ FUNCTIONS
;; ---------------------------------------------

;; Check if a given principal is a donor
(define-read-only (is-donor (user principal))
  (ok (is-some (map-get? donors { user: user })))
)

;; Get all donor data (Note: simulated as read-only due to Clarity limitations)
(define-read-only (get-donor-info (user principal))
  (let ((amount (default-to u0 (get amount (map-get? donors { user: user })))))
    (if (> amount u0)
        (ok { user: user, total-donated: amount })
        (err u104)
    )
  )
)
