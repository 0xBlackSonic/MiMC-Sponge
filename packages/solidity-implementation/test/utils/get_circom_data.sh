#!/bin/bash

file=$(find "../circom-implementation/build/output.json" -type f)
line_no=$1
i=0

while read line; do
    i=$(( i + 1))
    test $i = $line_no && res="$line";
done < "$file"

echo $res