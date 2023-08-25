#!/bin/bash

circomDir="packages/circom-implementation"
solidityDir="packages/solidity-implementation"

# Generate circom implementation
cd ${circomDir}
bash hash.sh
cd ../..

# Check verification
cd ${solidityDir}
forge test --match-test testVerifySolidityAndCircomResults