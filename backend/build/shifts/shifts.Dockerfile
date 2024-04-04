#
# SHIFTS ---------------------------------------------------------------------------------------------
#
# %help
# SHIFTS description...
# 


# our base image
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive

# Install main packages
RUN apt-get update -y
RUN apt-get install -y vim
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y unzip

# Declare local variables
ARG LOCAL_DIR=""
ARG INSTALLATION_HOME=/opt/ptm-compass
RUN mkdir -p "${INSTALLATION_HOME}"


################
# REQUIREMENTS #
################

# Install Python packages
RUN apt-get -y install python-is-python3 python3-pip python3-venv
RUN python -m pip install --upgrade pip

# IMPORTANT!! Install this package for PeakInspector????
# apt-get -y install  python-tk

#################
# ENV VARIABLES #
#################

# Setting up the environment variables
ENV SRC_HOME ${INSTALLATION_HOME}/shifts


################
# INSTALLATION #
################

# Dowloand the tagged version
# RUN wget https://github.com/CNIC-Proteomics/SHIFTS-4/archive/refs/tags/v0.4.1.zip
# # Clone the SHIFTS repository
# RUN git clone https://github.com/CNIC-Proteomics/SHIFTS-4.git ${SRC_HOME}
COPY ${LOCAL_DIR}SHIFTS-4 ${SRC_HOME}

# Python environment --

# Declare the Python requirement file
ARG PYTHON_REQ_FILE="python_requirements_shifts.txt"

# Create venv
RUN cd ${SRC_HOME} && python -m venv env

# Requirements for Python
COPY ${LOCAL_DIR}${PYTHON_REQ_FILE} /tmp/.
RUN cd ${SRC_HOME} && /bin/bash -c "source ${SRC_HOME}/env/bin/activate && pip install -r /tmp/${PYTHON_REQ_FILE}"
