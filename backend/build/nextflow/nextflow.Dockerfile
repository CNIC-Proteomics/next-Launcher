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
ARG LOCAL_DIR=""
ARG INSTALLATION_HOME=/opt/nextflow
RUN mkdir -p "${INSTALLATION_HOME}"


# BEGIN: for debugging ----

# Install VSC
# RUN apt-get install -y gpg
# COPY code_1.82.3-1696245001_amd64.deb /tmp/.
# RUN  apt-get install -y /tmp/code_1.82.3-1696245001_amd64.deb

# END: for debugging ----

################
# REQUIREMENTS #
################

# Install the requirements for nextflow
RUN apt-get install -y openjdk-19-jre-headless

# Install the requirements for nf-core
RUN apt-get -y install python-is-python3 python3-pip python3-venv
RUN python -m pip install --upgrade pip

# # Install the requirements for singularity
# RUN apt-get -y install build-essential libseccomp-dev libglib2.0-dev pkg-config squashfs-tools cryptsetup runc


############
# NEXTFLOW #
############

# Install nextflow
RUN mkdir -p /usr/local/bin && cd /usr/local/bin && curl -s https://get.nextflow.io | bash
# RUN echo 'export PATH=/usr/local/nextflow:$PATH' >> /home/nextflow/.bashrc && source /home/nextflow/.bashrc
# RUN echo 'export PATH=/usr/local/nextflow:$PATH' >> /home/nextflow/.bashrc

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


# ###############
# # SINGULARITY #
# ###############

# # Install go
# RUN export VERSION=1.20.5 OS=linux ARCH=amd64 && cd /tmp && wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && rm go$VERSION.$OS-$ARCH.tar.gz

# # Set the Environment variable PATH to point to Go
# RUN echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc && source ~/.bashrc

# # Download SingularityCE from a release
# RUN export VERSION=3.11.3 && wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-ce-${VERSION}.tar.gz && tar -xzf singularity-ce-${VERSION}.tar.gz && cd singularity-ce-${VERSION}

# # Compile the SingularityCE source code
# RUN ./mconfig && make -C builddir && make -C builddir install


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


#######
# SGE #
#######

# # https://github.com/gawbul/docker-sge

# # Setting up the environment variables
# ENV SGE_ROOT "/opt/sge"
# RUN mkdir -p "${SGE_ROOT}"

# # Install requirements
# RUN apt-get install -y build-essential cmake git libdb5.3-dev libhwloc-dev libmotif-dev libncurses-dev libpam0g-dev libssl-dev libsystemd-dev libtirpc-dev libxext-dev pkgconf csh ant


# # Download repository
# # clone the SGE git repository
# # cd /opt && git clone https://github.com/daimh/sge.git
# COPY sge ${SGE_ROOT}/.

# # change working directory
# WORKDIR ${SGE_ROOT}/source

# # setup SGE env
# ENV SGE_CELL default
# RUN echo export SGE_ROOT=/opt/sge >> /etc/bashrc
# RUN echo export SGE_CELL=default >> /etc/bashrc
# RUN ln -s $SGE_ROOT/$SGE_CELL/common/settings.sh /etc/profile.d/sge_settings.sh

# export JAVA_HOME=/usr/lib/jvm/java-19-openjdk-amd64


# # install SGE
# RUN mkdir /opt/sge
# RUN useradd -r -m -U -d /home/sgeadmin -s /bin/bash -c "Docker SGE Admin" sgeadmin
# RUN usermod -a -G sudo sgeadmin
# # RUN sh scripts/bootstrap.sh && ./aimk && ./aimk -man
# # RUN echo Y | ./scripts/distinst -local -allall -libs -noexit
# WORKDIR $SGE_ROOT
# RUN ./inst_sge -m -x -s -auto ~/sge_auto_install.conf \
# # && /etc/my_init.d/01_docker_sge_init.sh \
# && sed -i "s/HOSTNAME/`hostname`/" ${SGE_ROOT}/sge_exec_host.conf \
# && /opt/sge/bin/lx-amd64/qconf -au sgeadmin arusers \
# && /opt/sge/bin/lx-amd64/qconf -Me $HOME/sge_exec_host.conf \
# && /opt/sge/bin/lx-amd64/qconf -Aq $HOME/sge_queue.conf

# # https://hackmd.io/@lconcha/SkVKUSd39

# apt-get install -y build-essential cmake git libdb5.3-dev libhwloc-dev libmotif-dev libncurses-dev libpam0g-dev libssl-dev libsystemd-dev libtirpc-dev libxext-dev pkgconf

# cd /opt/sge
# cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/opt/sge
# cmake --build build -j
# cmake --install build


# # https://svennd.be/SGE_on_Ubuntu_20.04_LTS/


# RUN apt-get install -y gridengine-master gridengine-client gridengine-exec gridengine-qmon qt5-qmake

# RUN apt-get install -y gridengine-master gridengine-qmon xfonts-100dpi xfonts-75dpi


# RUN apt-get install -y gridengine-master gridengine-client gridengine-exec gridengine-qmon cpp
# RUN apt-get install -y qt5-qmake
# RUN ln -s /usr/bin/qmake /usr/lib/gridengine/qmake
# COPY template_sge_cell.conf /var/lib/gridengine/.
# RUN rm -rf /etc/init.d/sgemaster.proteomics /var/lib/gridengine/sge_cell
# RUN cd /var/lib/gridengine && ./install_qmaster -auto /var/lib/gridengine/template_sge_cell.conf

# cd /var/lib/gridengine/
# cp /mnt/tierra/quantMS-PTM/backend/build/nextflow/template_sge_cell.conf .
# rm -rf /etc/init.d/sgemaster.proteomics /var/lib/gridengine/sge_cell
# ./inst_sge -m -auto /var/lib/gridengine/template_sge_cell.conf
# ./install_qmaster -auto /var/lib/gridengine/template_sge_cell.conf



####################################
# ENVIRONMENT variables and EXPOSE #
####################################

# Setting up the enviroment of 'root' and 'nextflow' user
# COPY setup.root.sh /tmp/.
# RUN cat "/tmp/setup.root.sh" >> /root/.bashrc
# RUN chmod -R og+w /opt/nextflow/cache /opt/nextflow/tmp
# RUN addgroup nextflow
# RUN adduser --ingroup nextflow --disabled-password --gecos '' nextflow
# COPY setup.nextflow.sh /tmp/.
# RUN cat "/tmp/setup.nextflow.sh" >> /home/nextflow/.bashrc
USER root
COPY ${LOCAL_DIR}setup.root.sh /tmp/.
RUN cat "/tmp/setup.root.sh" >> /root/.bashrc

######################
# EXPOSE and COMMAND #
######################

# Expose port 8080 (the port your server will listen on).
EXPOSE 8080

# Define the command to execute when the container starts.
# CMD cd ${NXF_API_HOME} && ./scripts/startup-local.sh mongo
# CMD cd ${NXF_API_HOME} && ./scripts/startup-local.sh file

# Setting up the environment variables
# WORKDIR /opt/PTM-compass
WORKDIR /workspace
