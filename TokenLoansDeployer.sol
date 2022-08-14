pragma solidity ^0.5.0;

import "./TokenLoansMintable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";



// this is the first contract that we need to run
contract TokenLoansDeployer {

    // keep track of the token_address and arcade_sale_address as you will need them to 
    // visualize the contracts
    address public token_address;
    address public crowdsale_address;


    constructor(

    )
        public
    {

        // Create TokenLoans token with 18 decimal places, just like ether (see TokenLoansMintable.sol)
        TokenLoans token = new TokenLoans("TokenLoans", "TKL");
        token_address = address(token);


        // Create instance of TokenLoansCrowdsale and use the token we just created
        TokenLoansCrowdsale crowdsale = new TokenLoansCrowdsale(1, msg.sender, token);
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
