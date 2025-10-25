// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

import {Script} from "forge-std/Script.sol";
import {BasicNFT} from "src/BasicNFT.sol";

contract Deploy is Script {
    function run() public returns (BasicNFT) {
        vm.startBroadcast();
        BasicNFT basicNFT = new BasicNFT();
        vm.stopBroadcast();
        return (basicNFT);
    }
}
