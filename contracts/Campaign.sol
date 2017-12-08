// Contract Factory Practice

pragma solidity ^0.4.6;

contract Campaign {
  address public owner;
  uint public deadline;
  uint public goal;
  uint public fundsRaised;
  bool public refundsSent;

  struct FunderStruct {
    address funder;
    uint amount;
  }

  FunderStruct[] public fundersStructs;

  event LogContribution(address sender, uint amount);
  event LogRefundSent(address funder, uint amount);
  event LogWithdrawal(address beneficiary, uint amount);

  function Campaign(uint campaignDuration, uint campaignGoal) 
  public
  {
    owner = msg.sender;
    deadline = block.number + campaignDuration;
    goal = campaignGoal;
  }

  function isSuccess()
  public
  constant
  returns (bool isIndeed)
  {
    return (fundsRaised >= goal);
  }

  function hasFailed()
  public
  constant
  returns (bool hasIndeed)
  {
    return (fundsRaised < goal && block.number > deadline);
  }

  function contribute()
  public
  payable
  returns (bool success)
  {
    require(msg.value > 0);
    require(!isSuccess());
    require(!hasFailed());
    fundsRaised += msg.value;
    FunderStruct memory newFunder;
    newFunder.funder = msg.sender;
    newFunder.amount = msg.value;
    fundersStructs.push(newFunder);
    LogContribution(msg.sender, msg.value);
    return true;
  }

  function withdrawFunds()
  public
  returns (bool success)
  {
    require(msg.sender == owner);
    require(isSuccess());
    uint amount = this.balance;
    owner.transfer(amount);
    LogWithdrawal(owner, amount);
    return true;
  }

  function sendRefunds()
  public
  returns (bool success)
  {
    require(msg.sender == owner);
    require(hasFailed());
    require(!refundsSent);

    uint funderCount = fundersStructs.length;
    for(uint i=0; i < funderCount; ++i) {
      fundersStructs[i].funder.transfer(fundersStructs[i].amount);
      LogRefundSent(fundersStructs[i].funder, fundersStructs[i].amount);
    }
    refundsSent = true;
    return true;
  }
}
