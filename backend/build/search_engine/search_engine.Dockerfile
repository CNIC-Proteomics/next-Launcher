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
