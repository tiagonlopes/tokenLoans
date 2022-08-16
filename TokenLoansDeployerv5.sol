pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";


contract TokenLoans is ERC20, ERC20Detailed, ERC20Mintable {
    constructor(
    )
        ERC20Detailed("TokenLoans", "TKL", 18)
        public 
    {

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
        uint newvalue = msg.value*11/10;
        _mint(msg.sender,newvalue);
    }

}
