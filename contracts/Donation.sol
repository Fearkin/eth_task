//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Donation {
    address payable public owner;
    mapping(address => uint256) public donators;
    address[] public donated;

    event Transfer(address donator, uint256 value);
    event Withdrawal(uint256 value);

    constructor() {
        owner = payable(msg.sender);
    }

    function donate() public payable {
        require(msg.value == 0, "Value can't be equal to zero");
        
        uint256 amount = msg.value;
        if (donators[msg.sender] == 0) {
            donated.push(msg.sender);
        }
        donators[msg.sender] += amount;
        payable(address(this)).transfer(amount);

        emit Transfer(msg.sender, amount);
    }

    function withdraw(address payable to, uint256 amount) public {
        require(msg.sender == owner, "Only owner can do it");
        require(address(this).balance >= amount, "Insufficient funds");

        to.transfer(amount);

        emit Withdrawal(amount);
    }

    function getDonators() public view returns (address[] memory) {
        return donated;
    }

    function getSummaryDonation(address donator) public view returns (uint256) {
        return donators[donator];
    }

}
