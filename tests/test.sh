#!/bin/bash
source $(find "$( dirname -- "${BASH_SOURCE[0]}" )/.." -maxdepth 1 -name all.sh)

# Configure minimal test env
export CB_DIR="$(mktemp -ud)"
DIRS=( "$CB_DIR" )

# Run tests
FAILS=0 RUNS=0 DOUT=$(mktemp -d $PWDIR/tests/output.XXXX.$(date +%s))
for script in $(find $PWDIR/tests -mindepth 2 -type f -executable -name '*.sh'); do
	( set -x; $script; ) &>$(mktemp "$DOUT/test.$(basename $script).XXXX")
	if [[ $? -eq 0 ]]; then
		echo PASS $script
	else
		echo FAIL $script
		((FAILS++))
	fi
	((RUNS++))
done

# Statistics
echo $'--------\tDONE\t--------\nSee test output in '"$DOUT"
echo "Passed: $((RUNS - $FAILS)) in $RUNS tests"
[[ $FAILS > 0 ]] && echo "Failed: $FAILS tests"

# Cleanup
rm -rf ${DIRS[@]}
exit $FAILS
