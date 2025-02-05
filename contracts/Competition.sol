// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Competition {
    enum WinnerType { Random, Manual }

    struct CompetitionInfo {
        address creator;
        uint256 prizePool;
        uint256 startTime;
        uint256 endTime;
        WinnerType winnerType;
        address[] participants;
        bool isActive;
        address winner;
        bool isRewardClaimed;
    }

    CompetitionInfo public competition;

    event Participated(address indexed participant);
    event WinnerAnnounced(address indexed winner);
    event RewardClaimed(address indexed winner, uint256 amount);

    modifier onlyCreator() {
        require(msg.sender == competition.creator, "Only the creator can perform this action");
        _;
    }

    modifier competitionActive() {
        require(competition.isActive, "Competition is not active");
        _;
    }

    constructor(address _creator, uint256 _prizePool, uint256 _startTime, uint256 _endTime, WinnerType _winnerType) payable {
        require(_endTime > _startTime, "End time should be after start time");
        require(msg.value >= _prizePool, "Initial prize pool must be funded");

        competition = CompetitionInfo({
            creator: _creator,
            prizePool: msg.value,
            startTime: _startTime,
            endTime: _endTime,
            winnerType: _winnerType,
            participants: new address[](0) ,
       isActive: true,
            winner: address(0),
            isRewardClaimed: false
        });
    }

    function participate() external payable competitionActive {
        require(msg.value > 0, "Participation requires some ETH");
        require(block.timestamp >= competition.startTime, "Competition has not started yet");
        require(block.timestamp <= competition.endTime, "Competition has ended");

        competition.participants.push(msg.sender);
        competition.prizePool += msg.value;

        emit Participated(msg.sender);
    }

    function announceWinner() external competitionActive onlyCreator {
        require(block.timestamp > competition.endTime, "Competition is still ongoing");
        require(competition.participants.length > 0, "No participants in the competition");

        if (competition.winnerType == WinnerType.Random) {
            uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp,  msg.sender))) % competition.participants.length;
            competition.winner = competition.participants[randomIndex];
        } else {
            competition.winner = msg.sender;
        }

        competition.isActive = false;
        emit WinnerAnnounced(competition.winner);
    }

    function claimReward() external {
        require(!competition.isActive, "Competition is still active");
        require(msg.sender == competition.winner, "Only the winner can claim the reward");
        require(!competition.isRewardClaimed, "Reward already claimed");
        require(competition.prizePool > 0, "No prize pool available");

        uint256 rewardAmount = competition.prizePool;
        competition.prizePool = 0;
        competition.isRewardClaimed = true;

        payable(msg.sender).transfer(rewardAmount);

        emit RewardClaimed(msg.sender, rewardAmount);
    }

    function getCompetitionDetails() external view returns (CompetitionInfo memory) {
        return competition;
    }
}
