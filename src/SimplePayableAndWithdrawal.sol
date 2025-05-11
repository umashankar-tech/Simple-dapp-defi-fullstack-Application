// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract SimplePayableAndWithdrawal {
    address internal owner;
    mapping(address => uint256) private s_FunderList;
    address[] private s_FunderAddresses;

    modifier ownable() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function fundToThisContract() public payable {
        if (s_FunderList[msg.sender] == 0) {
            s_FunderAddresses.push(msg.sender); 
        }
        s_FunderList[msg.sender] += msg.value;
    }

    function withdrawFund() external ownable {
        payable(owner).transfer(address(this).balance);
    }

    function totalFundRReceive() public view returns (uint256) {
        return address(this).balance;
    }

    function funderList() external view ownable returns (address[] memory, uint256[] memory) {
        uint256 funderCount = s_FunderAddresses.length;
        uint256[] memory fundedAmounts = new uint256[](funderCount);

        for (uint256 i = 0; i < funderCount; i++) {
            fundedAmounts[i] = s_FunderList[s_FunderAddresses[i]];
        }

        return (s_FunderAddresses, fundedAmounts);
    }
}
