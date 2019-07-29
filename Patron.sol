/* Course: BCDV1013
 * File: PatronFactory.sol
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
    * @dev Throws revert if called by any account other than the owner.
    */
    modifier onlyOwner {
        require(msg.sender == owner, "Unautorized access!");
        _;
    }

    /**
     * @dev Transfers the current balance to the owner.
     */
    function withdrawAll() public onlyOwner {
        owner.transfer(address(this).balance);
    }

    /**
     * @dev Transfers some wei to the owner.
     * @param _value The amount to be transfered.
     */
    function withdrawSome(uint256 _value) public onlyOwner {
        owner.transfer(_value);
    }

    /**
     * @dev Transfers the some wei to the _recipient address.
     * @param _recipient The recipient's address.
     * @param _value The amount to be transfered.
     */
    function withdrawToOtherAcc(address payable _recipient, uint256 _value) public onlyOwner {
        _recipient.transfer(_value);
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
    function destroyAndSendTo(address payable _recipient) public onlyOwner {
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
contract Patron is Ownable, Donatable, Destructible {

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account. Sets initial status of accepting donations true, which can be changed later.
     * @param _artistAddress Ethereum address of the artist, to make him owner of his account.
     */
    constructor(address payable _artistAddress) public {
        owner = _artistAddress;
        status = true;
    }

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

/**
 * @title PatronFactory
 * @dev Contract factory to deploy multiple instances of Patron contract.
 */
contract PatronFactory {
    mapping (uint => Patron) patronDeployments;
    mapping (uint => address) patronsByArtists;
    uint public totalDeployments;
    
    constructor() public {
        totalDeployments = 0;
    }
    
    /**
     * @dev Method to deploy Patron instance (account) and assign an ID to it.
     * @param _artistAddress Ethereum address of the artist.
     */
    function deployPatron(address payable _artistAddress) public {
        patronDeployments[totalDeployments] = new Patron(_artistAddress);
        patronsByArtists[totalDeployments] = _artistAddress;
        totalDeployments++;
    }

    /**
     * @dev Method to get Patron instance (account) for a given ID.
     * @param _id Integer value to point to the Patron (account) instance of the artist.
     */
    function getPatronDeploymentById( uint _id) public view returns (Patron) {
        return Patron(patronDeployments[_id]);
    }
}


/**
 * @title PatronDashboard
 * @dev Dashboard implementation to support PatronFactory and facilitate its use. Still under development
 */
contract PatronDashboard {
    PatronFactory database;
    
    /**
     * @dev Constructor method to deploy instance of Dashboard contract.
     * @param _database Address of the Factory contract's (PatronFactory) deployed isntance.
     */
    constructor(address _database) public {
        database = PatronFactory(_database);
    }
    
    /**
     * @dev Allows arbitrary artist (user) to deploy a patron contract, simply put create an account to accept donations.
     */
    function newPatronDeployment() public {
        database.deployPatron(msg.sender);
    }
    
    /**
     * @dev Proxy method to make a donation to any artist.
     * @param _id Integer value to point to the Patron (account) instance of the artist.
     */
    function donateToArtist(uint _id) public payable{
        Patron thisPatronInstance = database.getPatronDeploymentById(_id);
        thisPatronInstance.donate.value(msg.value)();
    }
}
