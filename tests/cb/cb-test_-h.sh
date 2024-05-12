#!/bin/bash -ex

WORKDIR="$(mktemp -d)"

export CB_DIR="$WORKDIR/.cb"
export CB_PROFILE="DEFAULT"
export CB_BOOKMARKS="$CB_DIR/$CB_PROFILE.lst"
export CB_EDITOR="$(which cat)"

# Cleanup
cleanup() { rm -rf $WORKDIR; exit $1; }
trap 'cleanup $?' EXIT

cb -h | grep Usage


