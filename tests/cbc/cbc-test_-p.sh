#!/bin/bash -ex

WORKDIR="$(mktemp -d)"

# Env
export CBC_DIR="$WORKDIR/.cbc"
export CBC_PROFILE="DEFAULT"
export CBC_BOOKMARKS="$CBC_DIR/$CBC_PROFILE.lst"
export CBC_EDITOR="$(which cat)"

# Setup
mkdir $CBC_DIR
cat >$CBC_BOOKMARKS<<'EOF'
touch $WORKDIR/test_file_1
touch $WORKDIR/test_file_2
touch $WORKDIR/test_file_3
touch $WORKDIR/test_file_4
touch $WORKDIR/test_file_5
EOF

# Cleanup
cleanup() { rm -rf $WORKDIR; exit $1; }
trap 'cleanup $?' EXIT

# Test
cbc -p | grep DEFAULT
cbc -p DELME
cbc -p | grep DELME
