#!/bin/bash

[[ -z ${CB_DIR+x} ]]	&&	export CB_DIR="$HOME/.cb"
[[ -z ${CB_PROFILE+x} ]] &&	export CB_PROFILE="DEFAULT"
[[ -z ${CB_BOOKMARKS+x} ]] && 	export CB_BOOKMARKS="$CB_DIR/$PROFILE.lst"

CB_HELP=cat<<-EOF
	# Usage: cb [-h][-e][-l][-p [PROFILE]] [BOOKMARK|INDEX]
	# -h --help	: Show this text
	# -e --edit	: Edit bookmark list
	# -l --list	: Show bookmark list
	# -p --profile	: List profiles or change to PROFILE
	# Example:
	# 	cb      	- cd to the first entry
	# 	cb games	- cd to first match including 'games'
	# 	cb -p dev linux	- cd to match of 'linux' in 'dev' profile & set profile
EOF



case ${1:0:1} in
	-)
		
