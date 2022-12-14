# Patron
> Submitted By: <br> Shailendra Shukla <br> 101224373

Inspired by the famous Patreon website where creators accept donations from their supporters, this contract tries to implement somewhat a similar use case serving the content creators/artists on blockchain.

So, there are six contracts implementing inheritance, abstract contract, events, and other concepts of solidity.
- First is the `Ownable` contract that has 1 modifier and 3 methods.
- Second contract is the `Destructible` contract with 2 methods.
- Third contract is the `Donatable` abstract contract having 1 event, 2 function signatures and 1 modifier.
- Fourth contract is the `Patron` contract which inherits all of the above contracts to implement 3 methods and emits 1 event declared in the Donatable class.
- Fifth contract is the `PatronFactory` contract which acts as a contract factory to deploy multiple instances of Patron contract.
- Lastly we have the sixth contract named `PatronDashboard` which is the Dashboard implementation to support PatronFactory and facilitate its use. This contract is still under development to implement all features of the Patron contract via proxy methods.

For the PatronFactory contract, signatures for the methods are given below.
```JS
function deployPatron(address payable _artistAddress) public {}
function getPatronDeploymentById( uint _id) public view returns (Patron) {}
```

Please go through the documentation in the Patron.sol file for other contracts, method signatures and implementation details. Though it is well documented but in case of lack of clarity please feel free to open an issue or make suggestions to the existing codebase creating a pull request or fork.

## Deployment
PatronDashboard Contract has been deployed to the testnet and can be found at etherscan.io, visit the following link: https://ropsten.etherscan.io/address/0x401b6dc3d1fd9ac02096237ee3c0f5e144e8f294

PatronFactory Contract has been deployed to the testnet and can be found at etherscan.io, visit the following link: https://ropsten.etherscan.io/address/0xcf239de9f8b3f3eb9caaeacb7bbb05f4616f7c5b

## Interacting with the Contracts
To interact with the PatronDashboard you can follow the steps below:
1. Call `newPatronDeployment()` to deploy make your patron account to accept donations
2. Call `donateToArtist(uint _id)` with an arbitrary account and send some ETH along with the artist ID (use 0 to test) as parameters, and you should see an output like this. (sent 3ETH)
```JSON 

{
  "from": "0x9e43...57df879031",
  "topic": "0xd77...465374401d38ae5...15ff9df3158f9b72a7",
  "event": "DonationSuccessful",
  "args": {
    "0": "0x76A846CD2a...a468423D",
    "1": "3000000000000000000",
    "from": "0x76A846CD2a...a468423D",
    "value": "3000000000000000000",
    "length": 2
  }
}
```
> **NOTE** : *An event has been fired named `DonationSuccessful` which shows the method has been executed successfully.*

To verify, you can connect to the first address using Patron contract and check its balance. Well, that's going to be implemented in near future with all other cool features. 
<br>This was implemeted just to demonstrate successful use of Dashboard and Factory implementation. A fully functional dApp is coming soon, fingers crossed!

## Extra information
Some higher level concepts of Solidity programming has been used in the contracts above, to name some 
- **Multiple contract interactions** There are six contracts in total and all of these are woven together to make this application a fully functional project. In order to do that successfully contracts *inherit* from other contracts. You can spot the use of *abstract contracts* which are implemented using *is* keyword in Solidity. Example code snippet is below for reference:
```JS
constructor(address _database) public {
  database = PatronFactory(_database);
}
```
- **Factory and Dashboard** implementation can be seen which makes the code quite functional in nature and gives the whole application a single entry point, avoiding hassle and making a single control point as the *Dashboard*. *Factory* here is used to enable deployment of multiple contract instances.
- **Passing values to parent functions** Life isn't that easy when you're writing some Solidity code so passing value from one method to other is a crucial concept. The method below is payable but it is a proxy method so it has to send all ETH it has recieved to the real implementation of the donate method. Look how it is implemented:
```JS
function donateToArtist(uint _id) public payable {
  Patron thisPatronInstance = database.getPatronDeploymentById(_id);
  thisPatronInstance.donate.value(msg.value)();
}
```
- **Clean dev documentation** - This may sound unimportant but as a developer I find it really crucial to document your code especially when it is for others to see or understand. Ideally, it should be slef explanatory but `@...` annotation and such documentation helps generate API docs encouraging clean code practices. 

## Do it yourself
You can deploy the Patron contract individually to use all of its functions. Given below is the function signature for all of its methods
```JS
function donate() public payable isDonationOpen {}
function setStatus(bool _status) public onlyOwner {}
function acceptedDonations() public view returns (uint256) {}
function withdrawAll() public onlyOwner {}
function withdrawSome(uint256 _value) public onlyOwner {}
function withdrawToOtherAcc(address payable _recipient, uint256 _value) public onlyOwner {}
function destroyAndSendTo(address payable _recipient) public onlyOwner {}
function destroy() public onlyOwner {}
```

## See Also
Documentation ref: https://ethereumdev.io/inheritance-in-solidity/

## Author
Shailendra Shukla, shailendra.shukla@georgebrown.ca
