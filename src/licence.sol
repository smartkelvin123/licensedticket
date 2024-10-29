// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


/**
 * @title LicenseManager
 * @dev cretaing a smart contract caled LicenseManager to manage licenses, the cost is 1 ether, owner can ask for free
 * 
 * 
 */

contract LicenseManager {
    address private owner;
    address[] private licensed;
    mapping (address => bool) private licenseOwner;


    constructor() {
        owner = msg.sender;
    }


    function buyLicenese() public payable  {
         require(msg.value == 1 ether  || msg.sender == owner, "send 1ether to buy a license. owners can ask for free");
         licensed.push(msg.sender);
         licenseOwner[msg.sender] = true;
    }

    function checkLicense() public view returns (bool) {
        return licenseOwner[msg.sender];
    }


  //  the blockchain is deterimistic, the varaibles are known, using them to calculate random element is not good
    function winLicense() public payable returns (bool) {
        require(msg.value >= 0.01 ether && msg.value <= 0.5 ether, "send between 0.01 and 0.5 ether to try your luck");
        uint maxThreshold = uint ((msg.value / 1e16));

        // bad design principle by using blockhass
        uint algorithm = uint (keccak256(abi.encodePacked(uint256(msg.value), msg.sender, uint(1337), blockhash(block.number-1))));
        uint pickedNumber = algorithm % 100;
        if (pickedNumber < maxThreshold) {
            licenseOwner[msg.sender] = true;
        }
        return licenseOwner[msg.sender];
    }

    function refundLicense() public {
        //checking if the refund address was registered as a licensed user
        require(licenseOwner[msg.sender] == true, "you are not a licensed user");

        for (uint i = 0; i < licensed.length; i++) {
            if (licensed[i] == msg.sender) {
                licensed[i] = licensed[licensed.length - 1];
                licensed.pop();
                break;
            }
        }
        (bool success, ) = msg.sender.call{value: 1 ether}("");
        require(success, "Transfer of ether failed");
        licenseOwner[msg.sender] = false;
    }

 function  collect() public {
    require(msg.sender == owner, "only the owner can collect funds");
    (bool success,) = msg.sender.call{value: address(this).balance}("");
    require(success, "Transfer of ether failed");
    
 }


}