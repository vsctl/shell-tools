#!/bin/bash -e

WORKDIR="$(mktemp -d)"

export CB_DIR="$WORKDIR/.cb"
export CB_PROFILE="DEFAULT"
export CB_BOOKMARKS="$CB_DIR/$CB_PROFILE.lst"
export CB_EDITOR="$(which cat)"

cb -h | grep Usage &>/dev/null


