# Patron

Inspired by the famous Patreon website where creators accept donations from their supporters, this contract tries to implement somewhat a similar use case serving the creators on blockchain.

So, there are four contracts implementing inheritance, abstract contract, events, and other concepts of solidity.
First is the Ownable contract that has 1 modifier and 3 methods.
Secondly, there is a Destructible contract with 2 methods.
Then there is a Donatable abstract contract having 1 event, 2 function signatures and 1 modifier.
Finally, we have the Patron contract which inherits all other contracts to implement 3 methods and emits 1 event declared in the Donatable class.

For the Ownable contract, signatures for the methods and modifiers are given below respectively.
```Solidity
modifier onlyOwner {}
function withdrawAll() public onlyOwner {}
function withdrawSome(uint256 _value) public onlyOwner {}
function withdrawToOtherAcc(address payable _recipient, uint256 _value) public onlyOwner {}
```
Please go through the documentation in the Patron.sol file for other contracts, method signatures and implementation details. Though it is well documented but in case of lack of clarity please fell free to open an issue or make suggestions to the existing codebase creating a pull request or fork.

Contract deployment details can be found at etherscan.io, visit the following link: https://rinkeby.etherscan.io/tx/0xb3c2f87b80ab8080659ac9812491c86f434dd6de0e4b610fdc0875f8000a6ce9


Dcumentation ref: https://ethereumdev.io/inheritance-in-solidity/