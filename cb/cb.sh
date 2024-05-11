#!/bin/bash

cb() {
[[ -z ${CB_DIR} ]]	&&	export CB_DIR="$HOME/.cb"
[[ -z ${CB_PROFILE} ]] &&	export CB_PROFILE="DEFAULT"
[[ -z ${CB_BOOKMARKS} ]] && 	export CB_BOOKMARKS="$CB_DIR/$CB_PROFILE.lst"
[[ -z ${CB_EDITOR} ]] &&	export CB_EDITOR="${EDITOR:-xdg-open}"

[[ -d $CB_DIR ]] || mkdir -p "$CB_DIR"

CB_HELP="$(cat<<-EOF
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
)"

cb_cat() (
	touch $CB_BOOKMARKS &>/dev/null
	cat $CB_BOOKMARKS | sed 's:^#.*::g;s:[[:space:]]+#.*::g;:^$:d;'
)

local rc=0
while true; do
  case "${1}" in
	-h|--help)
		echo "$CB_HELP"
		break
		;;
	-e|--edit)
		$CB_EDITOR $CB_BOOKMARKS
		shift
		;;
	-l|--list)
		cb_cat
		shift
		;;
	-p|--profile)
		shift
		if [[ -z $1 || ${1:0:1} == - ]]; then
		 	ls -1 $CB_DIR
		else
			export CB_PROFILE="$1"
			export CB_BOOKMARKS="$CB_DIR/$CB_PROFILE.lst"
			shift
		fi
		;;
	-*)
		echo "$CB_HELP" >&2
		rc=22
		break
		;;
	[0-9]*)
		CB_FIND="$(cb_cat | awk 'NR=='$1'{print $0}' | head -n 1)"
		[[ -z ${CB_FIND} ]] && rc=127
		eval cd $CB_FIND
		break
		;;
	*)
		[[ -z $1 ]] && eval cd $(cb_cat | head -n 1) && break
		CB_FIND="$(cb_cat | awk '/'$*'/{print $0}' | head -n 1)"
		[[ -z ${CB_FIND} ]] && rc=255 || eval cd $CB_FIND 
		break
		;;
  esac
  [[ -z ${1} ]] && break
done
return $rc
}
[[ -z ${@} ]] && export -f cb || cb $@ 
