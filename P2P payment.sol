// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract P2PPayment is Ownable{
    event PaymentSent(address indexed payer, address indexed payee, uint256 amount);

    mapping (address => bool) public isPayee;

    modifier onlyAuthorised() {
        require(isPayee[msg.sender],"Only the payer can call this function");
        _;
    }

    function togglePayee(address _payee) external onlyOwner {
        isPayee[_payee] = !isPayee[_payee];
    }

    function depositFunds() external payable {
        require(msg.value > 0, "You must send some ether to deposit.");
    }

    function sendPayment(address _to, uint256 _amountToSend) external payable onlyAuthorised {
        require(address(this).balance >= _amountToSend, "Insufficient funds to complete the payment.");
        payable(_to).transfer(_amountToSend);
        emit PaymentSent(msg.sender, _to, _amountToSend);
    }
}