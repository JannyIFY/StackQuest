;; StackQuest Game Contract
(define-data-var admin principal tx-sender)
(define-map players 
    principal 
    {
        level: uint,
        experience: uint,
        inventory: (list 10 uint),
        achievements: (list 5 uint)
    }
)
(define-non-fungible-token game-item uint)

;; Constants
(define-constant ERR-NOT-ADMIN (err u100))
(define-constant ERR-NOT-FOUND (err u101))
(define-constant ERR-INVALID-PARAMS (err u102))

;; Player Management
(define-public (register-player)
    (let ((player tx-sender))
        (ok (map-set players 
            player
            {
                level: u1,
                experience: u0,
                inventory: (list u0 u0 u0 u0 u0 u0 u0 u0 u0 u0),
                achievements: (list u0 u0 u0 u0 u0)
            }
        ))
    )
)

;; Game Item Management
(define-public (mint-item (item-id uint) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-ADMIN)
        (nft-mint? game-item item-id recipient)
    )
)

;; Player Progress
(define-public (gain-experience (amount uint))
    (let (
        (current-exp (get experience (unwrap! (map-get? players tx-sender) ERR-NOT-FOUND)))
        (new-exp (+ current-exp amount))
    )
        (ok (map-set players 
            tx-sender
            (merge (unwrap! (map-get? players tx-sender) ERR-NOT-FOUND)
                { experience: new-exp }
            )
        ))
    )
)

;; Achievement System
(define-public (unlock-achievement (achievement-id uint))
    (let ((current-achievements (get achievements (unwrap! (map-get? players tx-sender) ERR-NOT-FOUND))))
        (ok (map-set players
            tx-sender
            (merge (unwrap! (map-get? players tx-sender) ERR-NOT-FOUND)
                { achievements: (unwrap! (as-max-len? 
                    (append current-achievements achievement-id) u5) 
                    ERR-INVALID-PARAMS) }
            )
        ))
    )
)

;; Rewards System
(define-public (claim-reward (achievement-id uint))
    (let (
        (player-data (unwrap! (map-get? players tx-sender) ERR-NOT-FOUND))
        (achievements (get achievements player-data))
    )
        (asserts! (is-some (index-of achievements achievement-id)) ERR-NOT-FOUND)
        (mint-item achievement-id tx-sender)
    )
)