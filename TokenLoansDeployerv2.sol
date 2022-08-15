pragma solidity ^0.5.0;

import "./TokenLoansMintablev2.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";



// this is the first contract that we need to run
contract TokenLoansDeployer {

    // keep track of the token_address and arcade_sale_address as you will need them to 
    // visualize the contracts
    address public token_address;
    address public crowdsale_address;
    address public wallet_address;

    constructor(

    )
        public
    {
        Wallet wallet = new Wallet();
        wallet_address = address(wallet);
        address payable wallet_address_payable = address(uint160(wallet_address)); // Correct since Solidity >= 0.5.0
        // Create TokenLoans token with 18 decimal places, just like ether (see TokenLoansMintable.sol)
        TokenLoans token = new TokenLoans("TokenLoans", "TKL");
        token_address = address(token);


        // Create instance of TokenLoansCrowdsale and use the token we just created
        TokenLoansCrowdsale crowdsale = new TokenLoansCrowdsale(1, wallet_address_payable, token);
        crowdsale_address = address(crowdsale);

        // @TODO: make the TokenLoansCrowdsale contract a minter, then have the TokenLoansDeployer renounce its minter role
        token.addMinter(crowdsale_address);
        token.renounceMinter();

    }
}


contract TokenLoansCrowdsale is Crowdsale, MintedCrowdsale {

    // This is the contract that provides the functionality for the sale of tokens
    constructor(
        uint rate,
        address payable wallet,
        TokenLoans token
    )
        Crowdsale(rate, wallet, token)
        public
    {

    }

}

// all the money raised during the sell of tokens will be parked in this contract
contract Wallet {

    function withdraw() public {
        msg.sender.transfer(address(this).balance);
    }

    function deposit() payable public {
        // nothing else to do!
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
        
    }
    function() external payable {
            // React to receiving ether
    }

}
