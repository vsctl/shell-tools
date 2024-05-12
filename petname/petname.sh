#!/bin/bash

petname() {
	DELIM=' '
	local WORDS=1
	while ! [[ -z $1 ]]; do
		if [[ ${1:0:2} == -d ]]; then
			DELIM="${1:2}"
			[[ ${#DELIM} == 0 ]] && DELIM="$2" && shift 
		else
			WORDS="$1"
		fi
		shift
	done
	# Common pre-installed wordlists
	WORDLISTS=( $(find /usr/share/dict -maxdepth 1 -type f -o -type l) )
	shuf -n $WORDS ${WORDLISTS[0]} | sed "s:'::g;"'s:[-&_+.\\]::g;' | paste -sd"$DELIM"
}
[[ -z $* ]] && export -f petname || petname "$@"
