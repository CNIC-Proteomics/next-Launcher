#!/bin/bash
# Startup script for local environment.

# home folder
HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)/.."

# parse command-line arguments
if [[ $# == 1 ]]; then
    BACKEND="$1"
else
	echo "usage: $0 <backend>"
	exit -1
fi

# initialize environment
#source ${HOME}/anaconda3/etc/profile.d/conda.sh
#conda activate nextflow-api

# start mongodb server
# if [[ ${BACKEND} == "mongo" ]]; then
#     sudo service mongodb start
#	  sudo systemctl start mongod
# fi
# start mongodb server
if [[ ${BACKEND} == "mongo" ]]; then
    scripts/db-startup.sh
fi

# start web server
export NXF_EXECUTOR="local"
export TF_CPP_MIN_LOG_LEVEL="3"

echo "${HOME_DIR}/bin/server.py --backend=${BACKEND}"
${HOME_DIR}/bin/server.py --backend=${BACKEND}
