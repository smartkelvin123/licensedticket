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
}


