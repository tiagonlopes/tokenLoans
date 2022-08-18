pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";


contract TokenLoans is ERC20, ERC20Detailed, ERC20Mintable {
    uint public fundraising_goal_in_wei;
    uint public discounted_price_for_1000TKL;
    uint public maturity_in_months;
    bool public fundraising_ended; // default is false
    mapping(address => uint256) private _investorTokens;
    uint private totalTokens;
    uint private numberOfInvestors;
    address[] private _investorAddresses;
    address public owner;

    constructor(
        uint  _fundraising_goal_in_wei,
        uint _discounted_price_for_1000TKL,
        uint _maturity_in_months
    )
        ERC20Detailed("TokenLoans", "TKL", 18)
        public 
    {
        fundraising_goal_in_wei = _fundraising_goal_in_wei;
        discounted_price_for_1000TKL = _discounted_price_for_1000TKL;
        maturity_in_months = _maturity_in_months;
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        // Underscore is a special character only used inside
        // a function modifier and it tells Solidity to
        // execute the rest of the code.
        _;
    }
    /*
    function() external payable {
        // fallback function to receive payments
    }
    */
    function totalFundsinWei() public view returns (uint256) {
        return address(this).balance;
    }
    /*
    function sellTKL_in_smallest_unit (uint amount) public payable{
        require (balanceOf(msg.sender)>= amount,"Not enough balance");
        _burn(msg.sender, amount);
        msg.sender.transfer(amount);
    }
    */
    function balanceOfSender () public view returns (uint){
        return balanceOf(msg.sender);
    }

    function buyTKL_with_wei() public payable{
        require (fundraising_ended==false, "fundraising has ended, sorry!");
        uint balance = address(this).balance;
        require (balance<=fundraising_goal_in_wei, "either the borrower has reached the goal or your order is too large");
        uint newvalue = msg.value*1000/discounted_price_for_1000TKL;
        if (_investorTokens[msg.sender]==0){
            _investorAddresses.push(msg.sender);
            numberOfInvestors = numberOfInvestors+1;
        }
        _mint(msg.sender,newvalue);
        _investorTokens[msg.sender] = _investorTokens[msg.sender].add(newvalue);
        totalTokens = totalTokens + newvalue;
        if(balance == fundraising_goal_in_wei){
            fundraising_ended = true;
        }
    }

    function sendPaymentToInvestors (uint amount) public onlyOwner payable{
        require (fundraising_ended==true, "fundraising hasn't ended, sorry!");
        for (uint i = 0; i < numberOfInvestors; i++) {
            uint investorPayment = amount * _investorTokens[_investorAddresses[i]]/totalTokens;
            address wallet_address = _investorAddresses[i];
            address payable wallet_address_payable = address(uint160(wallet_address));
            wallet_address_payable.transfer(investorPayment);
            _burn(_investorAddresses[i], investorPayment);
        }
    }
    
    function makeMonthlyPayment() public onlyOwner payable{
        uint monthlyPayment = totalTokens/maturity_in_months;
        sendPaymentToInvestors (monthlyPayment);
    }
    function outanding_tokens_minus_contract_funds() public view returns (uint256) {
        uint amount = totalSupply() - address(this).balance ;
        return amount;
    }

    function withdraw_funds(uint amount) public onlyOwner payable{
        require (fundraising_ended==true, "fundraising hasn't ended, sorry!");
        msg.sender.transfer(amount);
    }
    function deposit () public onlyOwner payable{
        require (fundraising_ended==true, "fundraising hasn't ended, sorry!");
        msg.value;
    }

}
