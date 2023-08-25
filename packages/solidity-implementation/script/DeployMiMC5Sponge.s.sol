// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {Hasher} from "../src/MiMC5Sponge.sol";

contract DeployMiMC5Sponge is Script {
    function run() external returns (Hasher) {
        Hasher hasher = new Hasher();
        return hasher;
    }
}
