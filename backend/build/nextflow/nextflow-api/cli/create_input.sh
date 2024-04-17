#!/bin/bash
# Create an input instance on a nextflow server.

# parse command-line arguments
if [[ $# != 1 ]]; then
	echo "usage: $0 <url>"
	exit -1
fi

URL="$1"
PIPELINE="$2"

# create a input instance
curl -s \
	-X POST \
	-d "{\"pipeline\":\"${PIPELINE}\"}" \
	${URL}/api/inputs/0

echo
