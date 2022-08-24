# TokenLoans

<p align='center'> <img src='images/decentrilized_fiance.jpg'></p>

TokenLoans is a solidity contract that allows borrowers to fundraise Ether for a project. Investors can buy the tokens produced by the contract and they get paid back in equal monthly installments including an interest. The borrower selects the terms of the contract.

The borrower sells its tokens at a discount and has to buy them back at parity. 

## Sell Tokens

In this example the user sells its tokens at a ratio of 900 to 1000 i.e. 900 Ether gives the investor 1000 tokens. 

<p align='left'> <img src='images/discounted_rate.jpg'></p>

## Buy Back the Tokens

The user has to buy back the tokens at parity i.e. 1 token gives back 1 Ether. The tokens produced by the contract have the same number of decimals (18) as Ether.
<p align='left'> <img src='images/parity_rate.jpg'></p>

The difference between the sell and buy price is the interest the investor makes. The user has to pay in equal monthly installments. 

## What the Contract Cannot Do

* Force payment
* Schedule a payment 

Every solidity contract has these limitations. The Ethereum Virtual Machine does not offer a scheduling service and it cannot extract money from a private wallet. The contract, however, does provide two public variables that can be used to determine the health of the contract: percentage_paid_to_investors and contract_ended_successfully (this boolean turns true if the investors were paid within the timeframe stated by the borrower).

## How to Set Up the Contract

The contract has 5 constructors (as seen in Remix IDE):

<p align='left'> <img src='images/constructors.jpg'></p>

1) Fundraising goal in wei: If the borrower wants 1 Ether it will have to put 1 followed by 18 zeros. 
2) Discounted price for 1000TKL: How much will an investor pay for 1000 of the borrower's tokens? This will define the exchange rate the borrower is selling its tokens for. 1000 means that the investors get zero interest. We suggest a number between 950 and 800.
3) Maturity in months: How many equal monthly payments does the borrower want to make?
4) Number of fundraising days: The borrower has to define a period for the fundraising. If the time ends and the goal hasn't been reached investors can pull their money out. 
5) Grace period in months: number of months before the borrower has to start making payments. 









