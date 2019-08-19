#!/usr/bin/env bash

[[ $# -ne 2 ]] && \
	echo "Usage : create-notification <title> <desc>"  \
	exit 1

push_notification_dir="${HOME}/.pushnotification"

echo "$1 : $2" > ${push_notification_dir}/${RANDOM}
