// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";

contract MeterRecharge is Ownable {
    // Event declaration for recharge actions.
    event Recharged(address indexed user, uint256 ethAmount, uint256 powerUnits);

    // Conversion rate from ETH to power units.
    uint256 public conversionRate;

    mapping(address => uint256) public powerUnitBalances;

    constructor(uint256 _initialConversionRate) Ownable(msg.sender) {
        conversionRate = _initialConversionRate;
    }

//    // Modified constructor to accept and pass the initial owner address to the Ownable constructor.
//    constructor(uint256 _initialConversionRate, address _initialOwner) Ownable(_initialOwner) {
//        conversionRate = _initialConversionRate;
//    }

    // Function to update the conversion rate (only by the owner).
    function updateConversionRate(uint256 _newRate) external onlyOwner {
        conversionRate = _newRate;
    }

    // Function to recharge the meter.
    function recharge() external payable {
        require(msg.value > 0, "Payment must be greater than 0");

        uint256 powerUnits = calculatePowerUnits(msg.value);
        powerUnitBalances[msg.sender] += powerUnits; // Update the sender's balance
        emit Recharged(msg.sender, msg.value, powerUnits);
    }

    // Calculate the power units from the ETH sent.
    function calculatePowerUnits(uint256 _ethAmount) public view returns (uint256) {
        return _ethAmount * conversionRate;
    }

    function getBalance(address user) public view returns (uint256) {
        return powerUnitBalances[user];
    }

    // Withdraw function to transfer out the contract's balance (only by the owner).
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
