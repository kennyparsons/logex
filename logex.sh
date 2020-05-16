#!/bin/bash

IFS='|'

# Functions
print_usage(){
	echo "* indicates a required option"
	echo "-f	* the log file"
	echo "-u	the username associated with the log"
}

set_user_name(){
	echo "What is your name? [ `whoami` ] "
	read myname
	if [ -z "$myname" ]; then
		myname=`whoami`
	fi
echo "Your log entries will use the name: ${myname}"
}

logex(){

	# get input for log message
	echo " "
	echo " "
	echo "New log message:"
	read -r logex_message

	#check for command message
	check_command $logex_message

	#send input to logger function
	logger $logex_message

	#clear screen and tail the log
	clear_screen
	tail_log

	#loop
	logex
}

logger(){
	updatetime
	echo "${timestamp}	$myname	$1" >> $f_flag
}

updatetime(){
	timestamp=$(date +%Y.%m.%d.%H.%M.%S)
}

check_command(){
	case $1 in
		"[[cat")
			# clear screen, cat the log, and call up logex/read
			clear_screen
			cat $f_flag
			logex
			;;
		"[[exit")
			exit 0
			;;
	esac
}

clear_screen(){
	#clear previous text
	clear >$(tty)
	
}

tail_log(){
	#review the last x lines
	tail -n 5 $f_flag
}

# Process inputs
f_flag=''
u_flag=''

while getopts 'f:u:' flag; do
        case "${flag}" in
                f) f_flag=${OPTARG} ;;
                u) u_flag=${OPTARG} ;;
                *) print_usage
                        exit 1 ;;
        esac
done

if [ -z "$f_flag" ]; then
	print_usage
	exit 1
fi

if [ -z "$u_flag" ]; then
	set_user_name
else
	myname=${u_flag}
fi

clear_screen
tail_log
logex

exit 0
