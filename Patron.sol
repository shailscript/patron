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
    * @dev Throws revert if called by any account other than the owner.
    */
    modifier onlyOwner {
        require(msg.sender == owner, "Unautorized access!");
        _;
    }
}


/**
 * @title Destructible
 * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
 */
contract Destructible is Ownable {

  constructor() internal payable { }

  /**
   * @dev Transfers the current balance to the owner and terminates the contract.
   */
  function destroy() public onlyOwner {
    selfdestruct(owner);
  }

  /**
   * @dev Transfers the current balance to the _recipient address and terminates the contract.
   * @param _recipient The address to transfer the current balance to.
   */
  function destroyAndSend(address payable _recipient) public onlyOwner {
    selfdestruct(_recipient);
  }
}

/**
 * @title Donatable
 * @dev Base abstract contract that will be used to implement donation characteristics.
 */
contract Donatable{
    event DonationSuccessful(address from, uint value);
    bool internal status;
    function setStatus(bool) public;
    function donate() public payable;

    /**
    * @dev Throws revert if status is false (not accepting).
    */
    modifier isDonationOpen {
        require(status == true, "Sorry we aren't accepting donations right now. Thank You!");
        _;
    }
}

/**
 * @title Patron
 * @dev The Patron contract implements the feature of accepting transactions
 * on behalf of the owner for this contract.
 */
contract Patron is Ownable, Donatable, Destructible{

    /**
    * @dev Allows the current owner to set donation status (Accepting/Not accepting).
    * @param _status Boolean value true or false for Accepting and Not-Accepting respectively.
    */
    function setStatus(bool _status) public onlyOwner {
        status = _status;
    }

    /**
    * @dev Allows the public domain to transfer funds to the contract.
    */
    function donate() public payable isDonationOpen{
        require(msg.sender != owner, "You can't donate funds to yourself, dear.");
        require(msg.value > 0 ether, "Insufficient transfer value.");
        emit DonationSuccessful(msg.sender, msg.value);
    }

    /**
    * @dev Allows the public domain to view total balance in the contract.
    * Likely to be used by the acceptors for setting a target public can verify.
    */
    function acceptedDonations() public view returns (uint256) {
        return address(this).balance;
    }
}
