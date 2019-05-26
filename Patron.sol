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

  function destroyAndSend(address payable _recipient) public onlyOwner {
    selfdestruct(_recipient);
  }
}

/**
 * @title Destructible
 * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
 */
contract Donatable{
    bool internal status;
    function setStatus(bool) public;
    function donate() public payable;
    modifier isDonationOpen {
        require(status == false, "Sorry we aren't accepting donations right now. Thank You!");
        _;
    }
}

/**
 * @title Patron
 * @dev The Owner contract has an owner address, and provides basic authorization control
 * modifier, this simplifies the implementation of "user permissions".
 */
contract Patron is Ownable, Donatable, Destructible{

    /**
    * @dev Allows the current owner to set donation status (Accepting/Not accepting).
    * @param _status The address to transfer ownership to.
    */
    function setStatus(bool _status) public onlyOwner {
        status = _status;
    }

    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    */
    function donate() public payable isDonationOpen{
        require(msg.value > 0 ether, "Insufficient transfer value.");
    }

    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    */
    function acceptedDonations() public view returns (uint256) {
        return address(this).balance;
    }
}