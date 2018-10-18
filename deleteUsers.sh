#!/usr/bin/env bash

# Delets student users from "Summary Faculty Class List" in asap.
# Just copy the entire table directly from the web page to a file
# and pass it as the first argument.


if [[ $# -ne 1 ]] ; then
	echo "usage: $0 <studentlist>"
	exit 1
fi

while read line ; do
	abc123=$(echo "$line" | sed -E 's/^.*@[0-9]{8}[\t ]+([a-z]{3}[0-9]{3}).*$/\1/')

	# delete the user if they exist
	if id -u "$abc123" &> /dev/null ; then
		userdel -r "$abc123"
	else
		echo "user $abc123 does not exist"
	fi

done < $1
