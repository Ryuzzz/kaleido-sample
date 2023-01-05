pragma solidity 0.4.24;

contract Vote {
    // structure
    struct candidator {
        string name;
        uint upVote;        
    }

    // variable
    candidator[] candidatorList;
    bool isVoting;
    address owner;
    address[] voterList;

    // mapping
    mapping(address => bool) voted; 

    // event
    event addCandidatorEvent(string name);
    event votingEvent(string candidatorName, uint candidatorUpVote);
    event finishVoteEvent(bool isVoting, address[] voterList);
    event startVoteEvent(address owner);

    // modifier
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    // constructor
    constructor() public {
        owner = msg.sender;
        isVoting = true;

        emit startVoteEvent(owner);
    }
    
    // add candidator
    function addCandidator(string name) public onlyOwner {
        require(isVoting == true);
        require(candidatorList.length < 5);
        candidatorList.push(candidator(name, 0));

        emit addCandidatorEvent(name);
    }

    // voting
    function voting(uint indexOfCandidator) public {
        require(isVoting == true);
        require(voted[msg.sender] == false);
        require(indexOfCandidator < candidatorList.length);
        candidatorList[indexOfCandidator].upVote++;

        voted[msg.sender] = true;
        voterList.push(msg.sender);
        emit votingEvent(candidatorList[indexOfCandidator].name, candidatorList[indexOfCandidator].upVote);
    }

    // finish vote
    function finishVote() public onlyOwner {
        require(isVoting == true);
        isVoting = false;

        emit finishVoteEvent(isVoting, voterList);
    }
    
    function result(uint indexOfCandidator) public view returns (string name, uint upVote) {
        name = candidatorList[indexOfCandidator].name;
        upVote = candidatorList[indexOfCandidator].upVote;
    }

}
