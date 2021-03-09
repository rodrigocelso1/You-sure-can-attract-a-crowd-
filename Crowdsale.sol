pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale{
    
    constructor(
        // @TODO: Fill in the constructor parameters!
        PupperCoin Coin , 
        uint rate, 
        address payable wallet,
        uint goal,  //goal for crowdsale
        uint starttime,
        uint endtime // uint time Cap
    )
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        Crowdsale(rate,wallet,Coin)
        TimedCrowdsale(starttime,endtime)
        CappedCrowdsale(goal)
        RefundableCrowdsale(goal)
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public Coin_sale_address;
    address public Coin_address;

    uint unlock_time;

    constructor(
        // @TODO: Fill in the constructor parameters!
        address payable wallet,
        string memory name,
        string memory symbol,
        uint initial_supply
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        PupperCoin Coin = new PupperCoin(name, symbol, 0);
        Coin_address = address(Coin);

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale Coin_sale = new PupperCoinSale(Coin, 1, wallet, initial_supply, now, now + 24 weeks);
        Coin_sale_address = address(Coin_sale);
        
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        Coin.addMinter(Coin_sale_address);
        Coin.renounceMinter();
    }
}