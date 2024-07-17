#
# NEXT-LAUNCHER-CORE: BACKEND ---------------------------------------------------------------------------------------------
#
# %labels
#     Author jmrodriguezc@cnic.es
#     Version v0.0.1
# 
# %help
#     This file create the Backend image that contains: nextflow, nextflow-api, etc.

# our base image
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Install main packages
RUN apt-get update -y
RUN apt-get install -y vim
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y zip
RUN apt-get install -y unzip


################
# REQUIREMENTS #
################

# Update packages
RUN apt-get update -y

# Install the requirements for nextflow, MSFragger
RUN apt-get install -y openjdk-19-jre-headless

# Install the requirements for nf-core, and some modules
RUN apt-get -y install python-is-python3 python3-pip python3-venv
RUN python -m pip install --upgrade pip

# ThermoRawFileParser:
RUN apt-get install -y ca-certificates gnupg
# install mono (ThermoRawFileParser)
RUN gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt-get update -y
RUN apt-get install -y mono-devel

# Nextflow-API: MongoDB.
RUN apt update -y
RUN apt install -y software-properties-common gnupg apt-transport-https ca-certificates
RUN wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc |  gpg --dearmor | tee /usr/share/keyrings/mongodb-server-7.0.gpg > /dev/null
RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
RUN apt update -y
RUN apt install -y mongodb-org
RUN apt install -y cron


#################
# ENV VARIABLES #
#################

# Declare local variables
ARG INSTALLATION_HOME=/opt
RUN mkdir -p "${INSTALLATION_HOME}"

# NEXTFLOW: Setting up the environment variables
ENV NXF_HOME=${INSTALLATION_HOME}/nextflow
RUN mkdir -p "${NXF_HOME}"
ENV NXF_CONF=${INSTALLATION_HOME}/nextflow/conf
RUN mkdir -p "${NXF_CONF}"
ENV NXF_WORK=${INSTALLATION_HOME}/nextflow/work
RUN mkdir -p "${NXF_WORK}"
ENV NXF_LOG=${INSTALLATION_HOME}/nextflow/log
RUN mkdir -p "${NXF_LOG}"

# NEXTFLOW-API: Setting up the environment variables
ARG NXF_API_VERSION=1.0
ENV NXF_API_HOME=${INSTALLATION_HOME}/nextflow-api
RUN mkdir -p "${NXF_API_HOME}"

# SEARCH_ENGINE: Setting up the environment variables
ENV SEARCH_ENGINE_HOME=${INSTALLATION_HOME}/search_engine
RUN mkdir -p "${SEARCH_ENGINE_HOME}"
ENV MSF_HOME=${SEARCH_ENGINE_HOME}/msfragger
# RUN mkdir -p "${MSF_HOME}" # not required
ENV RAWPARSER_HOME=${SEARCH_ENGINE_HOME}/thermorawfileparser
RUN mkdir -p "${RAWPARSER_HOME}"
ENV BIODATAHUB_HOME=${SEARCH_ENGINE_HOME}/biodatahub
RUN mkdir -p "${BIODATAHUB_HOME}"
ENV MZEXTRACTOR_HOME=${SEARCH_ENGINE_HOME}/mzextractor
RUN mkdir -p "${MZEXTRACTOR_HOME}"

# MSFRAGGER: Declare the file name (with version)
ARG MSF_FILE_NAME=MSFragger-3.8

# THERMORAWPARSER: Declare the file name (with version)
ARG RAWPARSER_FILE_NAME=ThermoRawFileParser1.4.2

# DECOYPYRAT: Setting up variables (with version)
ARG BIODATAHUB_VERSION=v2.13

# MZ_EXTRACTOR: Setting up variables (with version)
ARG MZEXTRACTOR_VERSION=v1.0

# PTM-COMPASS: Setting up the environment variables
ENV PTM_COMPASS_HOME=${INSTALLATION_HOME}/ptm-compass
RUN mkdir -p "${PTM_COMPASS_HOME}"

# REFMOD: Setting up the environment variables
ARG REFMOD_VERSION=v0.4.3
ENV REFMOD_HOME=${PTM_COMPASS_HOME}/refmod
RUN mkdir -p "${REFMOD_HOME}"

# SHIFTS: Setting up the environment variables
ARG SHIFTS_VERSION=v0.4.3
ENV SHIFTS_HOME=${PTM_COMPASS_HOME}/shifts
RUN mkdir -p "${SHIFTS_HOME}"

# SOLVER: Setting up the environment variables
ARG SOLVER_VERSION=v1.0
ENV SOLVER_HOME=${PTM_COMPASS_HOME}/solver
RUN mkdir -p "${SOLVER_HOME}"



#####################
# COPY REQUIREMENTS #
#####################

# NEXTFLOW: Copy Nextflow config files
COPY nextflow/conf ${NXF_CONF}/.

# MSFRAGGER: Copy file (with version)
COPY search_engine/${MSF_FILE_NAME}.zip /tmp/.

# THERMORAWPARSER: Copy file (with version)
COPY search_engine/${RAWPARSER_FILE_NAME}.zip /tmp/.



#
# NEXTFLOW ---------------------------------------------------------------------------------------------
#

# Install nextflow
RUN mkdir -p /usr/local/bin && cd /usr/local/bin && curl -s https://get.nextflow.io | bash

#
# NF-CORE ---------------------------------------------------------------------------------------------
#

# Python Package Index
RUN pip install nf-core

#
# NEXTFLOW-API ---------------------------------------------------------------------------------------------
#

# Clone the repository
RUN git clone https://github.com/CNIC-Proteomics/nextflow-api.git  --branch ${NXF_API_VERSION}  ${NXF_API_HOME}

# Requirements for Python
RUN pip install -r ${NXF_API_HOME}/python_requirements.txt

#
# SEARCH_ENGINE ---------------------------------------------------------------------------------------------
#

#############
# MSFRAGGER #
#############

# Install MSFragger
# unzip local file
RUN unzip /tmp/${MSF_FILE_NAME}.zip -d  ${SEARCH_ENGINE_HOME}/
# rename the files because we don't want versions in the name
# take into account that the target name folder does not exist
RUN mv  ${SEARCH_ENGINE_HOME}/${MSF_FILE_NAME} ${MSF_HOME}
RUN mv ${MSF_HOME}/${MSF_FILE_NAME}.jar ${MSF_HOME}/MSFragger.jar

###################
# THERMORAWPARSER #
###################

# Install ThermoRawFileParser
RUN unzip /tmp/${RAWPARSER_FILE_NAME}.zip -d ${RAWPARSER_HOME}

##############
# DECOYPYRAT #
##############

# Clone the repository
RUN git clone https://github.com/CNIC-Proteomics/bioDataHub.git  --branch ${BIODATAHUB_VERSION}  ${BIODATAHUB_HOME}

# Python environment --
RUN cd ${BIODATAHUB_HOME} && python -m venv env
RUN cd ${BIODATAHUB_HOME} && /bin/bash -c "source ${BIODATAHUB_HOME}/env/bin/activate && pip install -r ${BIODATAHUB_HOME}/python_requirements.txt"

################
# MZ_EXTRACTOR #
################

# Clone the repository
RUN git clone https://github.com/CNIC-Proteomics/mz_extractor.git  --branch ${MZEXTRACTOR_VERSION}  ${MZEXTRACTOR_HOME}

# Python environment --
RUN cd ${MZEXTRACTOR_HOME} && python -m venv env
RUN cd ${MZEXTRACTOR_HOME} && /bin/bash -c "source ${MZEXTRACTOR_HOME}/env/bin/activate && pip install -r ${MZEXTRACTOR_HOME}/python_requirements.txt"



#
# REFMOD ---------------------------------------------------------------------------------------------
#

# Clone the repository
RUN git clone https://github.com/CNIC-Proteomics/ReFrag.git  --branch ${REFMOD_VERSION}  ${REFMOD_HOME}

# Python environment --
RUN cd ${REFMOD_HOME} && python -m venv env
RUN cd ${REFMOD_HOME} && /bin/bash -c "source ${REFMOD_HOME}/env/bin/activate && pip install -r ${REFMOD_HOME}/python_requirements.txt"



#
# SHIFTS ---------------------------------------------------------------------------------------------
#

# Clone the repository
RUN git clone https://github.com/CNIC-Proteomics/SHIFTS.git  --branch ${SHIFTS_VERSION}  ${SHIFTS_HOME}

# Python environment --
RUN cd ${SHIFTS_HOME} && python -m venv env
RUN cd ${SHIFTS_HOME} && /bin/bash -c "source ${SHIFTS_HOME}/env/bin/activate && pip install -r ${SHIFTS_HOME}/python_requirements.txt"



#
# SOLVER ---------------------------------------------------------------------------------------------
#

# Clone the repository
RUN git clone https://github.com/CNIC-Proteomics/Solvers-PTMap.git  --branch ${SOLVER_VERSION}  ${SOLVER_HOME}

# Python environment --
RUN cd ${SOLVER_HOME} && python -m venv env
RUN cd ${SOLVER_HOME} && /bin/bash -c "source ${SOLVER_HOME}/env/bin/activate && pip install -r ${SOLVER_HOME}/python_requirements.txt"



#
# EXPOSE and COMMAND ---------------------------------------------------------------------------------------------
#

# Setting up the enviroment of 'root' and 'nextflow' user
USER root
COPY setup.root.sh /tmp/.
RUN cat "/tmp/setup.root.sh" >> /root/.bashrc

# Use ARG to define a build-time variable with a default value
ARG PORT_CORE=8080
ARG PORT_APP=3000
# ARG HOST_IP

# Use that ARG to set an environment variable
ENV PORT_CORE=${PORT_CORE}
ENV PORT_APP=${PORT_APP}
# ENV HOST_IP=${HOST_IP}

# Expose port given by input parameter.
EXPOSE ${PORT_CORE}

# Define the command to execute when the container starts.
# CMD cd ${NXF_API_HOME} && ./scripts/startup-local.sh mongo
# CMD cd ${NXF_API_HOME} && ./scripts/startup-local.sh file
# CMD [ "sh", "-c", "cd ${NXF_API_HOME} && ./scripts/startup-local.sh file" ]

# Setting up the environment variables
WORKDIR /workspace

