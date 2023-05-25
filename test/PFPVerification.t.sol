// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "ds-test/test.sol";
import "../src/TestPFP.sol";
import "../src/PFPVerification.sol";

contract PFPVerificationTest is Test {
    event VerificationAdded(address indexed contract_);

    event VerificationRemoved(address indexed contract_);

    PFPVerification public pv;
    TestPFP public testPFP;
    TestPFP public testPFP1;
    address public testPFPAddress;
    address public testPFPAddress1;
    address[] public pfpAddresses;

    function setUp() public {
        pv = new PFPVerification();
        testPFP = new TestPFP("Test PFP", "TPFP");
        testPFP1 = new TestPFP("Test PFP1", "TPFP1");
        testPFPAddress = address(testPFP);
        testPFPAddress1 = address(testPFP1);
        pfpAddresses.push(testPFPAddress);
        pfpAddresses.push(testPFPAddress1);
    }

    function testAddVerification() public {
        vm.expectEmit(true, false, false, true);

        emit VerificationAdded(testPFPAddress);
        pv.addVerification(pfpAddresses);
        assertTrue(pv.isVerified(testPFPAddress));
    }

    function testRemoveVerification() public {
        pv.addVerification(pfpAddresses);

        vm.expectEmit(true, false, false, true);

        emit VerificationRemoved(testPFPAddress);
        pv.removeVerification(pfpAddresses);
        assertFalse(pv.isVerified(testPFPAddress));
    }

    function testGetVerifiedCollections() public {
        pv.addVerification(pfpAddresses);
        address[] memory verified = pv.getVerifiedCollections();
        assertEq(verified.length, 2);
        pfpAddresses.pop();
        pv.removeVerification(pfpAddresses);
        address[] memory verifiedAfterRemove = pv.getVerifiedCollections();
        assertEq(verifiedAfterRemove.length, 1);
    }
}
