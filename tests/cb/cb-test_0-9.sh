#!/bin/bash -ex

WORKDIR="$(mktemp -d)"

# Env
export CB_DIR="$WORKDIR/.cb"
export CB_PROFILE="DEFAULT"
export CB_BOOKMARKS="$CB_DIR/$CB_PROFILE.lst"
export CB_EDITOR="$(which cat)"

# Setup
mkdir $CB_DIR
cat >$CB_BOOKMARKS<<EOF
$(mktemp -d $WORKDIR/tmp.XXXX)
$(mktemp -d $WORKDIR/tmp.XXXX)
$(mktemp -d $WORKDIR/tmp.XXXX)
$(mktemp -d $WORKDIR/tmp.XXXX)
$(mktemp -d $WORKDIR/tmp.XXXX)
EOF

# Cleanup
cleanup() { rm -rf $WORKDIR; exit $1; }
trap 'cleanup $?' EXIT

# Test
# cb 0 - Fails
cb 1
cb 2
cb 3
cb 4
cb 5
