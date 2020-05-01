#!/bin/sh

set -e

QUEUE_SIZE="$(postqueue -j 2> /dev/null | wc -l)"

if [ $# -eq 0 ]; then
	echo "${QUEUE_SIZE}"
elif [ "${QUEUE_SIZE}" -gt "$1" ]; then
	exit 1
fi
