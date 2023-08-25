#!/bin/bash

CIRCUIT=MiMC5Sponge
buildDir="build"
inputFileName="../input.json"
witnessFileName="witness.wtns"
outputFileName="output.json"

mkdir -p ${buildDir}

# Compile the circuit
circom ${CIRCUIT}.circom --wasm -o ${buildDir}

cd ${buildDir}

# Generate the witness
node ${CIRCUIT}_js/generate_witness.js ${CIRCUIT}_js/${CIRCUIT}.wasm ${inputFileName} ${witnessFileName}

# Export witness to json output
snarkjs wtns export json ${witnessFileName} ${outputFileName}

