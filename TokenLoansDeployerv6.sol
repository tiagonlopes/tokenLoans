pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";


contract TokenLoans is ERC20, ERC20Detailed, ERC20Mintable {
    uint public fundraising_goal_in_wei;
    uint public discounted_price_for_1000TKL;
    bool public fundraising_ended; // default is false
    constructor(
        uint  _fundraising_goal_in_wei,
        uint _discounted_price_for_1000TKL
    )
        ERC20Detailed("TokenLoans", "TKL", 18)
        public 
    {
        fundraising_goal_in_wei = _fundraising_goal_in_wei;
        discounted_price_for_1000TKL = _discounted_price_for_1000TKL;
    }

    function() external payable {
        // fallback function to receive payments
    }
    function totalFundsinWei() public view returns (uint256) {
        return address(this).balance;
    }
    function sellTKL_in_smallest_unit (uint amount) public payable{
        require (balanceOf(msg.sender)>= amount,"Not enough balance");
        _burn(msg.sender, amount);
        msg.sender.transfer(amount);
    }
    function balanceOfSender () public view returns (uint){
        return balanceOf(msg.sender);
    }

    function buyTKL_with_wei() public payable{
        require (fundraising_ended==false, "fundraising has ended, sorry!");
        uint balance = address(this).balance;
        require (balance<=fundraising_goal_in_wei, "either the investor has reached the goal or your order is too large");
        uint newvalue = msg.value*1000/discounted_price_for_1000TKL;
        _mint(msg.sender,newvalue);
        if(balance == fundraising_goal_in_wei){
            fundraising_ended = true;
        }
    }
    /*
    //I am trying to write a for loop to send a payment to investors
    //proportional to their number of tokens
    function sendPaymentToInvestors (uint amount) public payable{
        require (fundraising_ended==true, "fundraising hasn't ended, sorry!");
        uint provisional_totalSupply = _totalSupply;
        for (uint256 i = 0; i < _balances.length; i++) {
            uint investorPayment = amount * _balances[i]/provisional_totalSupply;
            address(i).transfer(investorPayment);
            _burn(address(i), investorPayment);
        }
    }
    */

}
