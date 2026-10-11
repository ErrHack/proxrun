#!/usr/bin/env bash

connect_to_host() {
	ssh $1
}

check_connection() {
	ssh -o BatchMode=yes -o ConnectTimeout=5 $1 true 2>&1
	return $?
}

read -rp "Enter host: " host
error=$(check_connection $host)
status=$?
echo "exit code is: $status"

if [ "$status" -eq 0 ]; then
    echo "There is no error. Connecting to $host!"
    exit 0 & connect_to_host $host
else
    echo "error is $error"
    wakeonlan a0:8c:fd:e9:6f:46
    while [ "$status" -ne 0 ]; do
    	echo "...checking connection..."
    	check_connection $host
    	status=$?
    done
    exit 0 & connect_to_host $host
fi
