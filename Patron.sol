/* Course: BCDV1010
 * File: Patron.sol
 * Submitted By:
       Shailendra Shukla
       101224373
 */

pragma solidity ^0.5.0;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * modifier, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address payable internal owner;
    
    /**
    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
    * account.
    */
    constructor() internal {
        owner = msg.sender;
    }
    
    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner {
        require(msg.sender == owner, "Unautorized access!");
        _;
    }
}
