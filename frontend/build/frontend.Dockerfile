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
ARG INSTALLATION_HOME=/opt

################
# REQUIREMENTS #
################

# Download the Node.js setup script
RUN curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
# Run the Node.js setup script with sudo 
RUN bash nodesource_setup.sh
# Install Node.js
RUN apt-get install -y nodejs


#################
# ENV VARIABLES #
#################

# Setting up the environment variables
ENV NEXTLAUNCHER_HOME  ${INSTALLATION_HOME}/next-launcher


################
# INSTALLATION #
################

# Dowload the app code
RUN git clone https://github.com/CNIC-Proteomics/next-Launcher.git ${NEXTLAUNCHER_HOME}

# Install npm packages for the app
RUN cd ${NEXTLAUNCHER_HOME}/app && npm install


######################
# EXPOSE and COMMAND #
######################

# Expose port (the port your server will listen on).
EXPOSE 3000

# Define the command to execute when the container starts.
# CMD cd ${NEXTLAUNCHER_HOME}/app && npm start

# Setting up the environment variables
WORKDIR /workspace
