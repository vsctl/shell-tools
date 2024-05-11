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
$(mktemp -d $WORKDIR/tmp.alpha.XXXX)
$(mktemp -d $WORKDIR/tmp.beta.XXXX)
$(mktemp -d $WORKDIR/tmp.gamma.XXXX)
$(mktemp -d $WORKDIR/tmp.delta.XXXX)
$(mktemp -d $WORKDIR/tmp.iota.XXXX)
EOF

# Cleanup
cleanup() { rm -rf $WORKDIR; exit $1; }
trap 'cleanup $?' EXIT

# Test
cb alpha; pwd | grep alpha
cb beta; pwd | grep beta
cb gamma; pwd | grep gamma
cb delta; pwd | grep delta
cb iota; pwd | grep iota
