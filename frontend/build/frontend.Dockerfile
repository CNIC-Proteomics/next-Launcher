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

# Download the Node.js setup script
# node v22
# RUN curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
# node v21
RUN curl -fsSL https://deb.nodesource.com/setup_21.x -o nodesource_setup.sh
# Run the Node.js setup script with sudo 
RUN bash nodesource_setup.sh
# Install Node.js
RUN apt-get install -y nodejs
# Install serve
RUN npm install -g serve


#################
# ENV VARIABLES #
#################

# Declare local variables
ARG NEXTLAUNCHER_VERSION=0.1.3
ARG INSTALLATION_HOME=/opt

# Setting up the environment variables
ENV NEXTLAUNCHER_HOME=${INSTALLATION_HOME}/next-launcher-app


################
# INSTALLATION #
################

# Dowload the app code
RUN git clone https://github.com/CNIC-Proteomics/next-Launcher-app.git  --branch ${NEXTLAUNCHER_VERSION}  ${NEXTLAUNCHER_HOME}

# Install npm packages for the app
RUN cd ${NEXTLAUNCHER_HOME}/app && npm install

# # Make build
# RUN cd ${NEXTLAUNCHER_HOME}/app && npm run build

###############
# ENVIRONMENT #
###############

# Use ARG to define a build-time variable
ARG PORT_APP
ARG SHARED_VOLUMES

# Use that ARG to set an environment variable
ENV PORT_APP=${PORT_APP}
ENV SHARED_VOLUMES=${SHARED_VOLUMES}

######################
# EXPOSE and COMMAND #
######################

# Expose port given by input parameter.
EXPOSE ${PORT_APP}
