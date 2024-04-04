#
# NEXTFLOW ---------------------------------------------------------------------------------------------
#
# %labels
#     Author jmrodriguezc@cnic.es
#     Version v0.0.1
# 
# %help
#     This file create the Backend image that contains: nextflow, nextflow-api, etc.


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
ARG LOCAL_DIR=nextflow/
ARG INSTALLATION_HOME=/opt/nextflow
RUN mkdir -p "${INSTALLATION_HOME}"


################
# REQUIREMENTS #
################

# Install the requirements for nextflow
RUN apt-get install -y openjdk-19-jre-headless

# Install the requirements for nf-core
RUN apt-get -y install python-is-python3 python3-pip python3-venv
RUN python -m pip install --upgrade pip


############
# NEXTFLOW #
############

# Install nextflow
RUN mkdir -p /usr/local/bin && cd /usr/local/bin && curl -s https://get.nextflow.io | bash

# Setting up the environment variables
ENV NXF_HOME ${INSTALLATION_HOME}/nextflow
RUN mkdir -p "${NXF_HOME}"
ENV NXF_WORK ${INSTALLATION_HOME}/nextflow/work
RUN mkdir -p "${NXF_WORK}"
ENV NXF_LOG ${INSTALLATION_HOME}/nextflow/log
RUN mkdir -p "${NXF_LOG}"


###########
# NF-CORE #
###########

# Python Package Index
RUN pip install nf-core


################
# NEXTFLOW-API #
################

# Setting up the environment variables
ENV NXF_API_HOME ${INSTALLATION_HOME}/nextflow-api
RUN mkdir -p "${NXF_API_HOME}"

COPY ${LOCAL_DIR}nextflow-api ${NXF_API_HOME}/.
RUN pip install -r ${INSTALLATION_HOME}/nextflow-api/python_requirements.txt

RUN apt update -y
RUN apt install -y software-properties-common gnupg apt-transport-https ca-certificates
RUN wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc |  gpg --dearmor | tee /usr/share/keyrings/mongodb-server-7.0.gpg > /dev/null
RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
RUN apt update -y
RUN apt install -y mongodb-org
RUN apt install -y cron


####################################
# ENVIRONMENT variables and EXPOSE #
####################################

# Setting up the enviroment of 'root' and 'nextflow' user
USER root
COPY ${LOCAL_DIR}setup.root.sh /tmp/.
RUN cat "/tmp/setup.root.sh" >> /root/.bashrc

######################
# EXPOSE and COMMAND #
######################

# Expose port 8080 (the port your server will listen on).
EXPOSE 8080

# Define the command to execute when the container starts.
CMD cd ${NXF_API_HOME} && ./scripts/startup-local.sh mongo
# CMD cd ${NXF_API_HOME} && ./scripts/startup-local.sh file

# Setting up the environment variables
# WORKDIR /opt/PTM-compass
WORKDIR /workspace




#
# SEARCH_ENGINE ---------------------------------------------------------------------------------------------
#
# %labels
#     Author jmrodriguezc@cnic.es
#     Version v0.0.1

# %help
#     This Singularity container is used for the search engine:
#     1. Obtain the DECOY using the DecoyPYrat (modified by jmrodriguezc)
#         https://www.sanger.ac.uk/science/tools/decoypyrat

#     2. Convert the raw file to mZML format using the ThermoRawFileParser:
#         https://github.com/compomics/ThermoRawFileParser
#         https://pubmed.ncbi.nlm.nih.gov/31755270/

#     3. Execution of MSFragger:
#         https://msfragger.nesvilab.org/


# # our base image
# FROM ubuntu:22.04
# ENV DEBIAN_FRONTEND noninteractive

# # Install main packages
# RUN apt-get update -y
# RUN apt-get install -y vim
# RUN apt-get install -y curl
# RUN apt-get install -y wget
# RUN apt-get install -y git
# RUN apt-get install -y unzip

# Declare local variables
ARG LOCAL_DIR=search_engine/
ARG INSTALLATION_HOME=/opt/search_engine
RUN mkdir -p "${INSTALLATION_HOME}"


################
# REQUIREMENTS #
################

# Requirements for MSFragger
RUN apt-get install -y openjdk-19-jre-headless

# Requeriments for ThermoRawFileParser
RUN apt-get install -y ca-certificates gnupg
# install mono (ThermoRawFileParser)
RUN gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt-get update -y
RUN apt-get install -y mono-devel

# Install Python packages
RUN apt-get -y install python-is-python3 python3-pip python3-venv
RUN python -m pip install --upgrade pip


#################
# ENV VARIABLES #
#################

# Setting up the environment variables
ENV MSF_HOME ${INSTALLATION_HOME}/msfragger
ENV RAWPARSER_HOME  ${INSTALLATION_HOME}/thermorawfileparser
ENV DECOYPYRAT_HOME  ${INSTALLATION_HOME}/dbscripts
ENV MZEXTRACTOR_HOME  ${INSTALLATION_HOME}/mz_extractor


#############
# MSFRAGGER #
#############

# Declare the file name (with version)
ARG FILE_NAME=MSFragger-3.8

# Install MSFragger
COPY ${LOCAL_DIR}${FILE_NAME}.zip /tmp/.
RUN unzip /tmp/${FILE_NAME}.zip -d  ${INSTALLATION_HOME}/
# rename the files because we don't want versions in the name
RUN mv  ${INSTALLATION_HOME}/${FILE_NAME} ${MSF_HOME}
RUN mv ${MSF_HOME}/${FILE_NAME}.jar ${MSF_HOME}/MSFragger.jar


###################
# THERMORAWPARSER #
###################

# Declare the file name (with version)
ARG FILE_NAME=ThermoRawFileParser1.4.2

# Install ThermoRawFileParser
COPY ${LOCAL_DIR}${FILE_NAME}.zip /tmp/.
RUN unzip /tmp/${FILE_NAME}.zip -d ${RAWPARSER_HOME}


##############
# DECOYPYRAT #
##############

# Clone the CNIC dbscripts repository that contains the DecoyPYrat
RUN git clone https://github.com/CNIC-Proteomics/iSanXoT-dbscripts.git  ${DECOYPYRAT_HOME}

# Python environment --

# Declare the Python requirement file
ARG PYTHON_REQ_FILE="python_requirements_decoypyrat.txt"

# Create venv
RUN cd ${DECOYPYRAT_HOME} && python -m venv env

# Requirements for Python
COPY ${LOCAL_DIR}${PYTHON_REQ_FILE} /tmp/.
RUN cd ${DECOYPYRAT_HOME} && /bin/bash -c "source ${DECOYPYRAT_HOME}/env/bin/activate && pip install -r /tmp/${PYTHON_REQ_FILE}"


################
# MZ_EXTRACTOR #
################

# Clone the program that extract the qauntifications
RUN git clone https://github.com/CNIC-Proteomics/mz_extractor.git  ${MZEXTRACTOR_HOME}

# Python environment --

# Declare the Python requirement file
ARG PYTHON_REQ_FILE="python_requirements_mzextractor.txt"

# Create venv
RUN cd ${MZEXTRACTOR_HOME} && python -m venv env

# Requirements for Python
COPY ${LOCAL_DIR}${PYTHON_REQ_FILE} /tmp/.
RUN cd ${MZEXTRACTOR_HOME} && /bin/bash -c "source ${MZEXTRACTOR_HOME}/env/bin/activate && pip install -r /tmp/${PYTHON_REQ_FILE}"



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


# # our base image
# FROM ubuntu:22.04
# ENV DEBIAN_FRONTEND noninteractive

# # Install main packages
# RUN apt-get update -y
# RUN apt-get install -y vim
# RUN apt-get install -y curl
# RUN apt-get install -y wget
# RUN apt-get install -y git
# RUN apt-get install -y unzip

# Declare local variables
ARG LOCAL_DIR=refrag/
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




#
# SHIFTS ---------------------------------------------------------------------------------------------
#
# %help
# SHIFTS description...
# 


# # our base image
# FROM ubuntu:22.04
# ENV DEBIAN_FRONTEND noninteractive

# # Install main packages
# RUN apt-get update -y
# RUN apt-get install -y vim
# RUN apt-get install -y curl
# RUN apt-get install -y wget
# RUN apt-get install -y git
# RUN apt-get install -y unzip

# Declare local variables
ARG LOCAL_DIR=shifts/
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



#
# SOLVER ---------------------------------------------------------------------------------------------
#
# %help
# SOLVER description...
# 


# # our base image
# FROM ubuntu:22.04
# ENV DEBIAN_FRONTEND noninteractive

# # Install main packages
# RUN apt-get update -y
# RUN apt-get install -y vim
# RUN apt-get install -y curl
# RUN apt-get install -y wget
# RUN apt-get install -y git
# RUN apt-get install -y unzip

# Declare local variables
ARG LOCAL_DIR=solver/
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
ENV SRC_HOME ${INSTALLATION_HOME}/solver


################
# INSTALLATION #
################

# Dowloand the tagged version
# RUN wget https://github.com/CNIC-Proteomics/SHIFTS-4/archive/refs/tags/v0.4.1.zip
# # Clone the SHIFTS repository
# RUN git clone https://github.com/CNIC-Proteomics/Solvers-PTMap.git ${SRC_HOME}
# RUN git clone https://github.com/CristinaDevesaA/TFM.git ${SRC_HOME}
COPY ${LOCAL_DIR}Solvers-PTMap ${SRC_HOME}

# Python environment --

# Declare the Python requirement file
ARG PYTHON_REQ_FILE="python_requirements_solver.txt"

# Create venv
RUN cd ${SRC_HOME} && python -m venv env

# Requirements for Python
COPY ${LOCAL_DIR}${PYTHON_REQ_FILE} /tmp/.
RUN cd ${SRC_HOME} && /bin/bash -c "source ${SRC_HOME}/env/bin/activate && pip install -r /tmp/${PYTHON_REQ_FILE}"
