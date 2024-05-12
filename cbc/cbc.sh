#!/bin/bash

cbc() {
[[ -z ${CBC_DIR} ]]	&&	export CBC_DIR="$HOME/.cbc"
[[ -z ${CBC_PROFILE} ]] &&	export CBC_PROFILE="DEFAULT"
[[ -z ${CBC_BOOKMARKS} ]] && 	export CBC_BOOKMARKS="$CBC_DIR/$CBC_PROFILE.lst"
[[ -z ${CBC_EDITOR} ]] &&	export CBC_EDITOR="${EDITOR:-xdg-open}"

[[ -d $CBC_DIR ]] || mkdir -p "$CBC_DIR"

CBC_HELP="$(cat<<-EOF
	# Usage: cbc [-h][-e][-l][-p [PROFILE]] [BOOKMARK|INDEX]
	# -h --help	: Show this text
	# -e --edit	: Edit bookmark list
	# -l --list	: Show bookmark list
	# -p --profile	: List profiles or change to PROFILE
	# Example:
	# 	cbc      	- show the first entry
	# 	cbc 2	 	- exec the second entry
	# 	cbc games	- exec first command that matches 'games'
	# 	cbc -p zig zls	- change to 'zig' profile and run first command with 'zls'
EOF
)"

cbc_cat() (
	touch $CBC_BOOKMARKS &>/dev/null
	cat $CBC_BOOKMARKS | sed 's:^#.*::g;s:[[:space:]]+#.*::g;:^$:d;'
)

local rc=0
while true; do
  case "${1}" in
	-h|--help)
		echo "$CBC_HELP"
		break
		;;
	-e|--edit)
		$CBC_EDITOR $CBC_BOOKMARKS
		shift
		;;
	-l|--list)
		cbc_cat
		shift
		;;
	-p|--profile)
		shift
		if [[ -z $1 || ${1:0:1} == - ]]; then
		 	ls -1 $CBC_DIR
		else
			export CBC_PROFILE="$1"
			export CBC_BOOKMARKS="$CBC_DIR/$CBC_PROFILE.lst"
			touch $CBC_BOOKMARKS
			shift
		fi
		;;
	-*)
		echo "$CBC_HELP" >&2
		rc=22
		break
		;;
	[0-9]*)
		CBC_FIND="$(cbc_cat | awk 'NR=='$1'{print $0}' | head -n 1)"
		[[ -z ${CBC_FIND} ]] && rc=127
		eval $CBC_FIND
		break
		;;
	*)
		[[ -z $1 ]] && cbc_cat && break
		CBC_FIND="$(cbc_cat | awk '/'$*'/{print $0}' | head -n 1)"
		[[ -z ${CBC_FIND} ]] && rc=255 || eval $CBC_FIND 
		break
		;;
  esac
  [[ -z ${1} ]] && break
done
return $rc
}
[[ -z ${@} ]] && export -f cbc || cbc $@ 
