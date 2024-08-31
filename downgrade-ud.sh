#!/bin/bash
# downgrade-ud 2021-03-23
# Dependencies: sudo pacutils
# Script to undo last update
# shellcheck disable=
#--------------------------------------------------------------------------------------------
help () {
cat << EOF
      
 |============================================================================================|
 |  Downgrade-ud: Script to undo last update. Intended for use after system update breakage.  |
 |  Running 'downgrade-ud -h' prints this info.                                               |
 |--------------------------------------------------------------------------------------------|
 |  USAGE: downgrade-ud [operation]                                                           |
 |                                                                                            |
 |  operations:  -rl  --readable_list    print 'hr' downgrade list (packages-versions)        |
 |               -dl  --downgrade_list   print 'pacman format' downgrade list                 |
 |               -dt  --downgrade_test   simulated downgrade (non transactional dry run)      |
 |               -dg  --downgrade        downgrade packages from list                         |
 |               -h   --help             print this help info                                 |
 |                                                                                            |
 |  Downgrade-ud gets the last update package list and the versions (pre-post updated)        |
 |  from /var/log/pacman.log. It downgrades with 'sudo pacman -U "\${DowngradeList[@]}"'.      |
 |                                                                                            |
 |  Downgrade-ud script location: $(which "$0")                                 |
 |============================================================================================|

EOF
}
#--------------------------------------------------------------------------------------------
# SET VARIABLES:

Today=$(date '+%Y-%m-%d')
Packages=$(paclog --after "${Today}" | paclog --action upgrade - \
				     | awk '{print $4" " $5}'	 \
				     | awk '!seen[$0]++'	 \
				     | awk -F'(' '{ gsub (" ", "", $0); print "/var/cache/pacman/pkg/" $1"-"$2}')

								# ^  Read pacman.log for last update     ^ #
								# filter to pkg-ver and prepend cache path #
readarray -t DowngradeList < <(for i in ${Packages}
				do
					find "${i}"* 2>/dev/null \
					| grep -v sig
				done)
					# ^   Run "${Packages}" through 'find' to check availability in    ^ #
					#  cache, discard unavailable, create DowngradeList array for pacman #

#--------------------------------------------------------------------------------------------
check () {
if	! [[ -v DowngradeList ]]; then
	printf '%s\n' "	
	There have been no updates made today, nothing to do.
	Downgradable list: ${DowngradeList[*]}
	"
	exit
fi
}
#--------------------------------------------------------------------------------------------
readable_list () {

	echo " todays date     : ${Today}" ; echo

	paclog --after "${Today}" | paclog --action upgrade -		\
				  | awk '{print $4" " $5" " $6" " $7}'	\
				  | awk '!seen[$0]++'			\
				  | column -t				\
				  | sort
}
#--------------------------------------------------------------------------------------------
downgrade_list () {

	printf '%s\n' "${DowngradeList[@]}"
}
#--------------------------------------------------------------------------------------------
downgrade_test () {

	sudo pacman -Up "${DowngradeList[@]}"
}
#--------------------------------------------------------------------------------------------
downgrade_packages () {

	sudo pacman -U "${DowngradeList[@]}"
}
#--------------------------------------------------------------------------------------------

if	[[ -z $1 ]]; then echo "
	A script to undo todays pacman update.
	"
fi

while :; do
		case "${1}" in
		-rl|--readable_list)	check ; readable_list		;;
		-dl|--downgrade_list)	check ; downgrade_list		;;
		-dt|--downgrade_test)	check ; downgrade_test		;;
		-dg|--downgrade)	check ; downgrade_packages	;;
         	 -h|--help)		help				;;
        	-?*)			echo "user input error"		;;
          	  *)  break
        	esac
    		shift
	 done
