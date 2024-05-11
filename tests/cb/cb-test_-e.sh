#!/bin/bash -e

WORKDIR="$(mktemp -d)"

export CB_DIR="$WORKDIR/.cb"
export CB_PROFILE="DEFAULT"
export CB_BOOKMARKS="$CB_DIR/$CB_PROFILE.lst"
export CB_EDITOR="$(which cat)"

mkdir $CB_DIR
echo "$(mktemp -d $WORKDIR/tmp.alpha.XXXX)" > $CB_BOOKMARKS

# Cleanup
cleanup() { rm -rf $WORKDIR; exit $1; }
trap 'cleanup $?' EXIT

cb -e | grep alpha &>/dev/null


