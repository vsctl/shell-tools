#!/bin/bash -ex

WORKDIR="$(mktemp -d)"

# Cleanup
cleanup() { rm -rf $WORKDIR; exit $1; }
trap 'cleanup $?' EXIT

for i in `seq 1 10`; do
[[ $(petname $i | wc -w) == $i ]]
done
[[ $(petname -d- 3 | grep -o - | wc -l) == 2 ]]
petname -d @+ 3 | grep '@.*+'
