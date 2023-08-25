// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Helper {
    function cleanCircomValues(bytes memory bytesToClean) public pure returns (uint256) {
        uint256 start = 0;
        uint256 end = bytesToClean.length;

        for (uint256 i = 0; i < bytesToClean.length; i++) {
            if (bytesToClean[i] == "\"") {
                start = i + 1;
                break;
            }
        }

        for (uint256 i = bytesToClean.length; i > 0; i--) {
            if (bytesToClean[i - 1] == "\"") {
                end = i - 1;
                break;
            }
        }

        bytes memory result = new bytes(end - start);
        uint256 numbers;

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = bytesToClean[start + i];
            if (uint8(result[i]) >= 48 && uint8(result[i]) <= 57) {
                numbers = numbers * 10 + (uint256(uint8(result[i])) - 48);
            }
        }

        return numbers;
    }
}
