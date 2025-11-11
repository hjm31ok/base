//此代码用于验证“Hold at least 1 ERC20 Pin NFTs”任务
//代码部署完毕后到下方地址验证
//https://docs.base.org/learn/token-development/erc-20-token/erc-20-exercise
//在验证过程中会出现验证失败的字样，不用管他，你已经验证成功，回去领取角色奖励吧


··································

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;
    
    uint256 public constant maxSupply = 1000000; // 1 million tokens (no decimals for this exercise)
    
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();
    
    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }
    

    Issue[] private issues;
    
    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }
    
    mapping(address => bool) public hasClaimed;
    
    constructor() ERC20("WeightedVoting", "WV") {
        
        issues.push();
        
        issues[0].issueDesc = "";
        issues[0].quorum = 0;
    }
    
    function decimals() public pure override returns (uint8) {
        return 0;
    }
    
    function claim() public {

        if (totalSupply() >= maxSupply) {
            revert AllTokensClaimed();
        }
        
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        
        uint256 claimAmount = 100;
        
        if (totalSupply() + claimAmount > maxSupply) {
            revert AllTokensClaimed();
        }
        
        hasClaimed[msg.sender] = true;
        _mint(msg.sender, claimAmount);
    }
    
    function createIssue(string memory _issueDesc, uint256 _quorum) external returns (uint256) {

        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }
        
        issues.push();
        uint256 issueIndex = issues.length - 1;
        
        Issue storage newIssue = issues[issueIndex];
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;
        newIssue.votesFor = 0;
        newIssue.votesAgainst = 0;
        newIssue.votesAbstain = 0;
        newIssue.totalVotes = 0;
        newIssue.passed = false;
        newIssue.closed = false;
        
        return issueIndex;
    }
    
    struct IssueView {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }
    
    function getIssue(uint256 _id) external view returns (IssueView memory) {
        require(_id < issues.length, "Issue does not exist");
        
        Issue storage issue = issues[_id];
        
        uint256 voterCount = issue.voters.length();
        address[] memory voterList = new address[](voterCount);
        
        for (uint256 i = 0; i < voterCount; i++) {
            voterList[i] = issue.voters.at(i);
        }
        
        return IssueView({
            voters: voterList,
            issueDesc: issue.issueDesc,
            votesFor: issue.votesFor,
            votesAgainst: issue.votesAgainst,
            votesAbstain: issue.votesAbstain,
            totalVotes: issue.totalVotes,
            quorum: issue.quorum,
            passed: issue.passed,
            closed: issue.closed
        });
    }
    
    function vote(uint256 _issueId, Vote _vote) public {
        require(_issueId < issues.length && _issueId > 0, "Invalid issue ID");
        
        Issue storage issue = issues[_issueId];
        
        if (issue.closed) {
            revert VotingClosed();
        }
        
        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }
        
        uint256 userTokens = balanceOf(msg.sender);
        if (userTokens == 0) {
            revert NoTokensHeld();
        }
        
        issue.voters.add(msg.sender);
        
        if (_vote == Vote.FOR) {
            issue.votesFor += userTokens;
        } else if (_vote == Vote.AGAINST) {
            issue.votesAgainst += userTokens;
        } else {
            issue.votesAbstain += userTokens;
        }
        
        issue.totalVotes += userTokens;
        
        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }
}
