// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {DeployMiMC5Sponge} from "../script/DeployMiMC5Sponge.s.sol";
import {Hasher} from "../src/MiMC5Sponge.sol";
import {Helper} from "./utils/Helper.sol";

contract MiMC5SopongeTest is Test {
    Hasher hasher;
    uint256[] params = new uint256[](4);

    function setUp() external {
        DeployMiMC5Sponge deployer = new DeployMiMC5Sponge();
        hasher = deployer.run();

        Helper helper = new Helper();

        string[] memory inputs = new string[](3);
        inputs[0] = "bash";
        inputs[1] = "./test/utils/get_circom_data.sh";

        for (uint256 i = 0; i < 4; i++) {
            inputs[2] = vm.toString(i + 3);
            bytes memory result = vm.ffi(inputs);
            params[i] = helper.cleanCircomValues(result);
        }
    }

    function testVerifySolidityAndCircomResults() public view {
        uint256 result = hasher.MiMC5Sponge([params[2], params[3]], params[1]);

        assert(uint256(params[0]) == result);
    }
}
