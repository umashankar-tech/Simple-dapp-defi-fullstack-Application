// SPDX-License-Identifier:MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {SimplePayableAndWithdrawal} from "src/SimplePayableAndWithdrawal.sol";

contract DeploySimplePayableAndWithdrawal is Script {
    SimplePayableAndWithdrawal public simplePayableAndWithDrawal;

    function run() external {
        vm.startBroadcast();
        simplePayableAndWithDrawal = new SimplePayableAndWithdrawal();
        vm.stopBroadcast();
    }
}
