# %labels
#     Author jmrodriguezc@cnic.es
#     Version v0.0.1
# 
# %help
#     This file create the web-app image


# our base image
FROM ubuntu:22.04

# Update apt package
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y


# Install packages
RUN apt-get install -y vim
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y git


################
# REQUIREMENTS #
################

# Install the requirements for web app
RUN apt-get install -y nodejs




###########
# WEB-APP #
###########



#########################
# ENVIRONMENT variables #
#########################

# Setting up the enviroment of 'root' and 'nextflow' user

# Setting up the environment variables
# WORKDIR /mnt/tierra/PTM-compass
WORKDIR /workspace

# Expose port (the port your server will listen on).
EXPOSE 3000
