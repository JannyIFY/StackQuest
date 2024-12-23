;; StackQuest Game Contract

;; Data Variables and Maps
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
    (begin 
        (ok (map-set players 
            tx-sender
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
        (player-data (unwrap! (map-get? players tx-sender) ERR-NOT-FOUND))
        (current-exp (get experience player-data))
        (new-exp (+ current-exp amount))
    )
        (ok (map-set players 
            tx-sender
            (merge player-data { experience: new-exp })
        ))
    )
)

;; Achievement System
(define-public (unlock-achievement (achievement-id uint))
    (let (
        (player-data (unwrap! (map-get? players tx-sender) ERR-NOT-FOUND))
        (current-achievements (get achievements player-data))
    )
        (ok (map-set players
            tx-sender
            (merge player-data
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

;; Battle System
(define-public (initiate-battle (opponent principal))
    (let (
        (player-data (unwrap! (map-get? players tx-sender) ERR-NOT-FOUND))
        (opponent-data (unwrap! (map-get? players opponent) ERR-NOT-FOUND))
        (player-level (get level player-data))
        (opponent-level (get level opponent-data))
    )
        (if (>= player-level opponent-level)
            (gain-experience u10)
            (ok true))
    )
)

;; Item Trading
(define-public (trade-item (item-id uint) (recipient principal))
    (begin
        (asserts! (is-eq (nft-get-owner? game-item item-id) (some tx-sender)) ERR-NOT-FOUND)
        (nft-transfer? game-item item-id tx-sender recipient)
    )
)

;; Quest System
(define-public (start-quest (quest-id uint))
    (let (
        (player-data (unwrap! (map-get? players tx-sender) ERR-NOT-FOUND))
        (current-level (get level player-data))
    )
        (asserts! (>= current-level u3) ERR-INVALID-PARAMS)
        (gain-experience u20)
    )
)

;; Player Leveling
(define-public (level-up)
    (let (
        (player-data (unwrap! (map-get? players tx-sender) ERR-NOT-FOUND))
        (current-exp (get experience player-data))
        (current-level (get level player-data))
    )
        (asserts! (>= current-exp (* current-level u100)) ERR-INVALID-PARAMS)
        (ok (map-set players 
            tx-sender
            (merge player-data
                { 
                    level: (+ current-level u1),
                    experience: u0
                }
            )
        ))
    )
)