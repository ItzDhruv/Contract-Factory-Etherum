# CompetitionFactory - Hardhat Project

This project implements a **Competition Factory** smart contract that allows users to create and participate in competitions on the Ethereum blockchain. Each competition is managed by a separate **Competition** contract deployed by the factory.

## Features
- **CompetitionFactory** contract:
  - Deploys new **Competition** contracts
  - Stores a list of all deployed competitions
  - Emits events when new competitions are created
- **Competition** contract:
  - Allows participants to join with an ETH deposit
  - Supports different winner selection mechanisms (Random/Manual)
  - Manages prize pool and winner distribution
  - Facilitates claiming of rewards

## Getting Started
### Prerequisites
Ensure you have the following installed:
- Node.js (v14 or later)
- Hardhat
- MetaMask (for interacting with the contracts)

### Installation
Clone the repository and install dependencies:
```shell
git clone https://github.com/ItzDhruv/Contract-Factory-Etherum.git
cd CompetitionFactory
npm install
```

### Compile the Smart Contracts
```shell
npx hardhat compile
```

### Deploy Contracts (Local Hardhat Node)
Start a local Hardhat node:
```shell
npx hardhat node
```
Deploy the contracts:
```shell
npx hardhat run scripts/deploy.js --network localhost
```

### Run Tests
```shell
npx hardhat test
```

## Deployment on Testnet/Mainnet
Update the `hardhat.config.js` file with your network details and deploy:
```shell
npx hardhat run scripts/deploy.js --network goerli
```

## Interaction with Contracts
You can use Hardhat tasks or scripts to interact with the deployed contracts.
Example: Get all competitions deployed by the factory
```shell
npx hardhat getAllCompetitions --network localhost
```

## License
This project is licensed under the MIT License.
