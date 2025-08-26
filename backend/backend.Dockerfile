#
# NEXT-LAUNCHER-CORE: BACKEND ---------------------------------------------------------------------------------------------
#
# %labels
#     Author jmrodriguezc@cnic.es
#     Version v0.1.6
# 
# %help
#     This file create the Backend image that contains: nextflow, singularity, and nextflow-api.

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
RUN apt-get install -y jq


################
# REQUIREMENTS #
################

# Update packages
RUN apt-get update -y

# Install the requirements for nextflow, MSFragger
RUN apt-get install -y openjdk-19-jre-headless

# Singularity:
# singularity dependencies
RUN apt-get update -y
RUN apt-get install -y \
    autoconf \
    automake \
    cryptsetup \
    fuse2fs \
    fuse \
    libfuse-dev \
    libglib2.0-dev \
    libseccomp-dev \
    libtool \
    pkg-config \
    runc \
    squashfs-tools \
    squashfs-tools-ng \
    uidmap \
    zlib1g-dev
# Install C compiler
RUN apt-get update -y
RUN apt-get install -y gcc build-essential

# Nextflow-API: MongoDB.
RUN apt update -y
RUN apt install -y software-properties-common gnupg apt-transport-https ca-certificates
RUN wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc |  gpg --dearmor | tee /usr/share/keyrings/mongodb-server-7.0.gpg > /dev/null
RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
RUN apt update -y
RUN apt install -y mongodb-org
RUN apt install -y cron

# Install the requirements for nf-core, and some modules
RUN apt-get -y install python-is-python3 python3-pip python3-venv python3-tk
RUN python -m pip install --upgrade pip


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
ENV NXF_PIPELINES=${INSTALLATION_HOME}/nextflow/pipelines
RUN mkdir -p "${NXF_PIPELINES}"
ENV NXF_SINGULARITY_CACHEDIR=${INSTALLATION_HOME}/nextflow/singularity
RUN mkdir -p "${NXF_SINGULARITY_CACHEDIR}"

# NEXTFLOW-API: Setting up the environment variables
ARG NXF_API_VERSION
ENV NXF_API_HOME=${INSTALLATION_HOME}/nextflow-api
RUN mkdir -p "${NXF_API_HOME}"

# SINGULARITY: Setting up the environment variables
ARG GO_VERSION
ARG SINGULARITY_VERSION
ENV SINGULARITY_HOME=${INSTALLATION_HOME}/singularity
RUN mkdir -p "${SINGULARITY_HOME}"



#####################
# COPY REQUIREMENTS #
#####################

# NEXTFLOW: Copy Nextflow config files
COPY nextflow/conf ${NXF_CONF}/.



#
# NEXTFLOW ---------------------------------------------------------------------------------------------
#

# Install nextflow
RUN mkdir -p /usr/local/bin && cd /usr/local/bin && curl -s https://get.nextflow.io | bash

#
# SINGULARITY ---------------------------------------------------------------------------------------------
#

# Install Go
RUN export OS=linux ARCH=amd64 && \
cd /tmp && \
wget https://dl.google.com/go/go${GO_VERSION}.$OS-$ARCH.tar.gz && \
tar -C /usr/local -xzvf go${GO_VERSION}.$OS-$ARCH.tar.gz && \
rm go${GO_VERSION}.$OS-$ARCH.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install Singularity
RUN cd /tmp && \
wget https://github.com/sylabs/singularity/releases/download/v${SINGULARITY_VERSION}/singularity-ce-${SINGULARITY_VERSION}.tar.gz && \
tar -xzf singularity-ce-${SINGULARITY_VERSION}.tar.gz && \
mv /tmp/singularity-ce-${SINGULARITY_VERSION}/* ${SINGULARITY_HOME}/. && \
rm -rf /tmp/singularity-ce-*
RUN cd ${SINGULARITY_HOME} && \
./mconfig && \
make -C builddir && \
make -C builddir install

#
# NEXTFLOW-API ---------------------------------------------------------------------------------------------
#

# Clone the repository
RUN git clone https://github.com/CNIC-Proteomics/nextflow-api.git  --branch ${NXF_API_VERSION}  ${NXF_API_HOME}

# Requirements for Python
RUN pip install -r ${NXF_API_HOME}/python_requirements.txt


#
# ENVIRONMENT ---------------------------------------------------------------------------------------------
#

# Setting up the environment of 'root' and 'nextflow' user
USER root
COPY setup.root.sh /tmp/.
RUN cat "/tmp/setup.root.sh" >> /root/.bashrc



#
# EXPOSE and COMMAND ---------------------------------------------------------------------------------------------
#

# Expose port given by input parameter.
EXPOSE ${PORT_CORE}
