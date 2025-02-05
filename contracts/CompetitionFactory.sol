// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Competition.sol"; // Import the Competition contract

contract CompetitionFactory {
    address[] public competitions; // Store deployed competition contracts

    event CompetitionCreated(address indexed competitionAddress, address indexed creator);
    function createCompetition(uint256 prizePool, uint256 startTime, uint256 endTime, Competition.WinnerType winnerType) external payable {
        require(msg.value >= prizePool, "Must send at least the prize pool amount");

        // Deploy a new Competition contract
        Competition newCompetition = new Competition{value: msg.value}(msg.sender, prizePool, startTime, endTime, winnerType);
        
        // Store the deployed contract address
        competitions.push(address(newCompetition));

        emit CompetitionCreated(address(newCompetition), msg.sender);
    }

    function getAllCompetitions() external view returns (address[] memory) {
        return competitions;
    }
}
