#!/usr/bin/env bash

# Creates student users from "Summary Faculty Class List" in asap.
# Usernames are abc123 IDs and passwords are banner IDs without '@'.
# Just copy the entire table directly from the web page to a file
# and pass it as the first argument.

if [[ $# -ne 1 ]] ; then
	echo "usage: $0 <studentlist>"
	exit 1
fi

while read line ; do
	regex='^[0-9]+[ \t]+([^,]+), (.+)[ \t]@([0-9]{8})[ \t]+([a-z]{3}[0-9]{3}).*$'
	
	last=$(echo "$line" | sed -E "s/$regex/\1/")
	first=$(echo "$line" | sed -E "s/$regex/\2/")
	banner=$(echo "$line" | sed -E "s/$regex/\3/")
	abc123=$(echo "$line" | sed -E "s/$regex/\4/")

	# create the user if they don't already exist
	if ! id -u "$abc123" &> /dev/null ; then
		useradd -G students --shell /bin/bash --comment "$first $last" -m -p $(openssl passwd -1 "$banner") "$abc123"
		echo "created user $abc123"
	else
		echo "user $abc123 already exists"
	fi

done < $1
