#
# REFRAG ---------------------------------------------------------------------------------------------
#
# %help
# ReCom rebuilt for MSFragger. Developed at the Cardiovascular Proteomics Lab / Proteomic Unit at CNIC (National Centre for Cardiovascular Research).
# 
# Requires:
# -i or --infile: Results file from MSFragger, in tab-separated text format.
# -r or --rawfile: MS Data file, in MGF or mzML format.
# -d or --dmfile: A theoretical DMs file, in tab-separated text format.
# -c or --config: A configuration file.
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


#################
# ENV VARIABLES #
#################

# Setting up the environment variables
ENV SRC_HOME ${INSTALLATION_HOME}/refrag


################
# INSTALLATION #
################

# # Declare the version
# ARG REFRAG_VERSION=0.4.2

# # Dowloand the tagged version
# # RUN wget https://github.com/CNIC-Proteomics/ReFrag/archive/refs/tags/${REFRAG_VERSION}.zip
# # Git clone repository
# RUN git clone https://github.com/CNIC-Proteomics/ReFrag.git  ${SRC_HOME}

# # Copy the tagged version
# COPY ${LOCAL_DIR}ReFrag-${REFRAG_VERSION}.zip /tmp/.
# RUN unzip /tmp/ReFrag-${REFRAG_VERSION}.zip -d /tmp/
# RUN mv /tmp/ReFrag-${REFRAG_VERSION} ${SRC_HOME}

# Copy master version
COPY ${LOCAL_DIR}ReFrag ${SRC_HOME}

# Python environment --

# Declare the Python requirement file
ARG PYTHON_REQ_FILE="python_requirements_refrag.txt"

# Create venv
RUN cd ${SRC_HOME} && python -m venv env

# Requirements for Python
COPY ${LOCAL_DIR}${PYTHON_REQ_FILE} /tmp/.
RUN cd ${SRC_HOME} && /bin/bash -c "source ${SRC_HOME}/env/bin/activate && pip install -r /tmp/${PYTHON_REQ_FILE}"
