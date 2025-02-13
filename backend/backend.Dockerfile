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
RUN apt-get -y install python-is-python3 python3-pip python3-venv python3-tk
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
ARG NXF_API_VERSION
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
ENV SEARCHTOOLKIT_HOME=${SEARCH_ENGINE_HOME}/searchtoolkit
RUN mkdir -p "${SEARCHTOOLKIT_HOME}"

# MSFRAGGER: Declare the file name (with version)
ARG MSF_FILE_NAME

# THERMORAWPARSER: Declare the file name (with version)
ARG RAWPARSER_FILE_NAME

# DECOYPYRAT: Setting up variables (with version)
ARG BIODATAHUB_VERSION

# SEARCH_TOOLKIT: Setting up variables (with version)
ARG SEARCHTOOLKIT_VERSION

# PTM-COMPASS: Setting up the environment variables
ARG PTM_COMPASS_VERSION
ENV PTM_COMPASS_HOME=${INSTALLATION_HOME}/ptm-compass

# REFMOD: Setting up the environment variables
ARG REFMOD_VERSION
ENV REFMOD_HOME=${PTM_COMPASS_HOME}/src/refmod



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

##################
# SEARCH_TOOLKIT #
##################

# Clone the repository
RUN git clone https://github.com/CNIC-Proteomics/SearchToolkit.git  --branch ${SEARCHTOOLKIT_VERSION}  ${SEARCHTOOLKIT_HOME}

# Python environment --
RUN cd ${SEARCHTOOLKIT_HOME} && python -m venv env
RUN cd ${SEARCHTOOLKIT_HOME} && /bin/bash -c "source ${SEARCHTOOLKIT_HOME}/env/bin/activate && pip install -r ${SEARCHTOOLKIT_HOME}/python_requirements.txt"



#
# PTM-COMPASS ---------------------------------------------------------------------------------------------
#

# Clone the repository
RUN git clone https://github.com/CNIC-Proteomics/PTM-compass.git  --branch ${PTM_COMPASS_VERSION}  ${PTM_COMPASS_HOME}

# Python environment --
RUN cd ${PTM_COMPASS_HOME} && python -m venv env
RUN cd ${PTM_COMPASS_HOME} && /bin/bash -c "source ${PTM_COMPASS_HOME}/env/bin/activate && pip install -r ${PTM_COMPASS_HOME}/python_requirements.txt"



#
# REFMOD ---------------------------------------------------------------------------------------------
#

# Clone the repository
RUN git clone https://github.com/CNIC-Proteomics/ReFrag.git  --branch ${REFMOD_VERSION}  ${REFMOD_HOME}

# Python environment --
RUN cd ${REFMOD_HOME} && python -m venv env
RUN cd ${REFMOD_HOME} && /bin/bash -c "source ${REFMOD_HOME}/env/bin/activate && pip install -r ${REFMOD_HOME}/python_requirements.txt"



#
# ENVIRONMENT ---------------------------------------------------------------------------------------------
#

# Setting up the environment of 'root' and 'nextflow' user
USER root
COPY setup.root.sh /tmp/.
RUN cat "/tmp/setup.root.sh" >> /root/.bashrc

# # Use ARG to define a build-time variable
# # server connection
# ARG PORT_CORE
# ARG PORT_APP
# ARG HOST_IP
# # mongodb connection.
# # Default PORT is required
# ARG MONGODB_HOST
# ARG MONGODB_PORT=27017
# ARG MONGODB_USER
# ARG MONGODB_PWD
# ARG MONGODB_DB
# # nextflow-api: guest user
# ARG USER_GUEST
# ARG PWD_GUEST
# # nextflow-api: admin user
# ARG USER_ADMIN
# ARG PWD_ADMIN
# # shared volumes
# ARG SHARED_VOLUMES

# # Use that ARG to set an ENV environment variable
# # server connection
# ENV PORT_CORE=${PORT_CORE}
# ENV PORT_APP=${PORT_APP}
# ENV HOST_IP=${HOST_IP}
# # mongodb connection
# ENV MONGODB_HOST=${MONGODB_HOST}
# ENV MONGODB_PORT=${MONGODB_PORT}
# ENV MONGODB_USER=${MONGODB_USER}
# ENV MONGODB_PWD=${MONGODB_PWD}
# ENV MONGODB_DB=${MONGODB_DB}
# # nextflow-api: guest user
# ENV USER_GUEST=${USER_GUEST}
# ENV PWD_GUEST=${PWD_GUEST}
# # nextflow-api: admin user
# ENV USER_ADMIN=${USER_ADMIN}
# ENV PWD_ADMIN=${PWD_ADMIN}
# # shared volumes
# ENV SHARED_VOLUMES=${SHARED_VOLUMES}



#
# EXPOSE and COMMAND ---------------------------------------------------------------------------------------------
#

# Expose port given by input parameter.
EXPOSE ${PORT_CORE}
