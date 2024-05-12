#!/bin/bash

petname() {
	USAGE="Usage: petname [-d DELIMITER] [WORD_COUNT]"
	DELIM=' '
	WORDS=1
	WORDLISTS=( $(find /usr/share/dict -maxdepth 1 -type f -o -type l) )
	while ! [[ -z $1 ]]; do
		if [[ ${1:0:2} == -d ]] || [[ $1 == --delimiter ]]; then
			DELIM="${1:2}"
			[[ ${#DELIM} == 0 ]] && DELIM="$2" && shift 
		elif [[ ${1:0:2} == -h ]] || [[ $1 == --help ]]; then
			echo $USAGE
			return
		else
			WORDS="$(tr -cd '[:digit:]' <<<$1)"
		fi
		shift
	done
	# Common pre-installed wordlists
	shuf -n $WORDS ${WORDLISTS[0]} | \
		sed "s:'::g;"'s:[-&_+.\\]::g;' | \
		paste -sd"$DELIM" 2>/dev/null || \
	echo $USAGE
}
[[ -z $* ]] && export -f petname || petname "$@"
