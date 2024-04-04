FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV NXF_VER="21.04.3"
EXPOSE 8080
EXPOSE 27017

# install package dependencies
RUN apt-get update -qq \
	&& apt-get install -qq -y \
		apt-transport-https \
		apt-utils \
		ca-certificates \
		cron \
		curl \
		git \
		mongodb \
		openjdk-8-jre \
		python3.7 \
		python3-pip \
		zip

# Install MongoDB in Ubuntu
# https://www.cherryservers.com/blog/install-mongodb-ubuntu-22-04
apt install -y software-properties-common gnupg apt-transport-https ca-certificates
wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc |  gpg --dearmor | tee /usr/share/keyrings/mongodb-server-7.0.gpg > /dev/null
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
apt update -y
apt install -y mongodb-org

# # https://www.mongodb.com/community/forums/t/installing-mongodb-over-ubuntu-22-04/159931
# wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc |  gpg --dearmor | tee /usr/share/keyrings/mongodb.gpg > /dev/null
# echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
# apt update -y
# apt install -y mongodb-org

#IMPORTANT: https://www.linode.com/docs/guides/install-mongodb-on-ubuntu-20-04/

# change python to refer to python 3.7
RUN rm /usr/bin/python3 && ln -s python3.7 /usr/bin/python3

# install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
	&& echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
	&& apt-get update -qq \
	&& apt-get install -qq -y kubectl

# install nextflow
RUN curl -s https://get.nextflow.io | bash \
	&& mv nextflow /usr/local/bin \
	&& nextflow info

# install nextflow-api from build context
WORKDIR /opt/nextflow-api

COPY . .

# install python dependencies
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt
