# StackQuest

A secure blockchain-based RPG game built on the Stacks ecosystem featuring NFT-based items and Bitcoin rewards.

## Core Features

- Player progression with experience and leveling
- NFT-based inventory management
- Secure marketplace for item trading
- Team-based gameplay mechanics
- Achievement system with rewards
- Price-controlled marketplace
- Automated safety checks

## Smart Contract Functions

### Player System
- `register-player`: Creates player profile with initial stats
- `gain-experience`: Awards XP with automated level checks
- `level-up`: Promotes players based on XP thresholds

### Market System
- `list-item-for-sale`: Lists NFT items with price validation
- `buy-item`: Processes secure marketplace transactions
- `get-market-listing`: Retrieves active listing details

### Team Mechanics
- `create-team`: Forms player teams with leadership
- `get-team-data`: Retrieves team composition

### Administration
- `set-admin`: Secure admin transfer with validation
- `mint-item`: Creates game items with ownership verification

## Security Features

- Price boundaries for market stability
- Level caps and progression controls
- Ownership verification for all item operations
- Active listing status tracking
- Admin operation safeguards
- Input validation across all functions

## Development Setup

1. Install Clarinet
```bash
curl -L https://install.clarinet.sh | sh
```

2. Setup Project
```bash
clarinet new stackquest
cd stackquest
```

3. Deploy Contract
```bash
clarinet contract:deploy
```

## Testing

Execute test suite:
```bash
clarinet test
```

## Future Enhancements

- Battle system integration
- Crafting mechanics
- Quest system
- Enhanced team features

## Contributing

1. Fork repository
2. Create feature branch
3. Submit pull request with tests