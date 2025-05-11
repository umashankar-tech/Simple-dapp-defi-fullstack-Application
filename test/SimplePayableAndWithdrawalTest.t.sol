// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {SimplePayableAndWithdrawal} from "src/SimplePayableAndWithdrawal.sol";

contract SimplePayableAndWithdrawalTest is Test {
    SimplePayableAndWithdrawal simplePayableAndWithdrawal;
    address owner = makeAddr("OWNER");
    address user = makeAddr("user");
    uint256 constant VALUE = 1e18;

    function setUp() public {
        vm.prank(owner);
        simplePayableAndWithdrawal = new SimplePayableAndWithdrawal();
    }

    function testFundToThisContract() public {
        vm.prank(user);
        vm.deal(user, VALUE);
        simplePayableAndWithdrawal.fundToThisContract{value: VALUE}();
        assertEq(address(simplePayableAndWithdrawal).balance, 1e18);
    }

    function testTotalFundReceive() public {
        vm.prank(user);
        vm.deal(user, VALUE);
        simplePayableAndWithdrawal.fundToThisContract{value: VALUE}();
        assertEq(
            simplePayableAndWithdrawal.totalFundRReceive(),
            address(simplePayableAndWithdrawal).balance
        );
    }

    function testWithdrawFund() public {
        vm.prank(user);
        vm.deal(user, VALUE);
        simplePayableAndWithdrawal.fundToThisContract{value: VALUE}();

        uint256 ownerBalanceBefore = owner.balance;

        vm.prank(owner);
        simplePayableAndWithdrawal.withdrawFund();
        assertEq(0, address(simplePayableAndWithdrawal).balance);

        uint256 ownerBalanceAfter = owner.balance;
        assertEq(ownerBalanceAfter, ownerBalanceBefore + VALUE);
    }

    function testFunderList() public {
        address user1 = makeAddr("user1");
        address user2 = makeAddr("user2");
        uint256 amount1 = 1 ether;
        uint256 amount2 = 2 ether;

        vm.deal(user1, amount1);
        vm.deal(user2, amount2);

        vm.prank(user1);
        simplePayableAndWithdrawal.fundToThisContract{value: amount1}();

        vm.prank(user2);
        simplePayableAndWithdrawal.fundToThisContract{value: amount2}();

        vm.prank(owner);
        (
            address[] memory funders,
            uint256[] memory amounts
        ) = simplePayableAndWithdrawal.funderList();

        assertEq(funders.length, 2);
        assertEq(amounts.length, 2);

        assertEq(funders[0], user1);
        assertEq(amounts[0], amount1);
        assertEq(funders[1], user2);
        assertEq(amounts[1], amount2);
    }
}
