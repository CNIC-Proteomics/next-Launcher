#
# NEXT-LAUNCHER: FRONTEND ---------------------------------------------------------------------------------------------
#
# %labels
#     Author jmrodriguezc@cnic.es
#     Version v0.0.1
# 
# %help
#     This file create the Fronend image that contains the web application

# our base image
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive

# Install main packages
RUN apt-get update -y
RUN apt-get install -y vim
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y zip
RUN apt-get install -y unzip

# Declare local variables
ARG LOCAL_DIR=nextflow/
ARG INSTALLATION_HOME=/opt

################
# REQUIREMENTS #
################

# Install the requirements for web app
RUN apt-get install -y nodejs


#################
# ENV VARIABLES #
#################

# Setting up the environment variables
ENV FRONTEND_HOME  ${INSTALLATION_HOME}/frontend


################
# INSTALLATION #
################

RUN git clone https://github.com/CNIC-Proteomics/next-Launcher ${FRONTEND_HOME}


######################
# EXPOSE and COMMAND #
######################

# Expose port (the port your server will listen on).
EXPOSE 3000

# Define the command to execute when the container starts.
# CMD cd ${FRONTEND_HOME}/fronend/app && npm start

# Setting up the environment variables
WORKDIR /workspace
