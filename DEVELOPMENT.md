# How to install WSL2 (Windows Subsystem for Linux 2) on Windows 10

https://pureinfotech.com/install-windows-subsystem-linux-2-windows-10/#install_wsl_command_2004_windows10
https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-11-with-gui-support#1-overview
https://linuxconfig.org/ubuntu-22-04-on-wsl-windows-subsystem-for-linux

1. Open Start on Windows 10.

2. Search for Command Prompt, right-click the top result, and select the Run as administrator option.

3. Type the following command to install the WSL on Windows 10 and press Enter:
```
wsl --install
```

4. Restart your computer to finish the WSL installation on Windows 10.

## Install WSL with specific distro

To install WSL with a specific distro on Windows 10, use these steps:

1. Open Start.

2. Search for Command Prompt, right-click the top result, and select the Run as administrator option.

3. Type the following command to view a list of available WSL distros to install on Windows 10 and press Enter:
```
	wsl --list --online
```
Quick note: At the time of this writing, you can install Ubuntu, Debian, Kali Linux, openSUSE, and SUSE Linux Enterprise Server.

4. Install the Ubuntu 22.04 from the Windows Store!!!

UNUSEFUL:
Type the following command to install the WSL with a specific distro on Windows 10 and press Enter:
```
wsl --install -d Ubuntu
```

## Increase the limiting Memory Usage in WSL2

https://www.aleksandrhovhannisyan.com/blog/limiting-memory-usage-in-wsl-2/

1. Check the current memory
You can check how much memory and swap space are allocated to WSL using the free command from within a WSL distribution:
```
free -h --giga
```

2. Create .wslconfig
Refer to the Microsoft docs on configuration settings for **.wslconfig** if you need help with this step. Below is the config that I’m currently using for my machine since I don't have a lot of RAM to work with:

"C:\Users\YourUsername\.wslconfig"
```
[wsl2]
memory=100GB
```

3. Restart WSL
You can either close out of WSL manually and wait a few seconds for it to fully shut down, or you could launch Command Prompt or PowerShell and run the following command to forcibly shut down all WSL distributions:
```
wsl --shutdown
```
4. Verify That WSL Respects .wslconfig
Finally, run the free command again to verify that WSL respects your specified resource limits:
```
free -h --giga
```

# Connect to tierra using Ubuntu


0. Update the apt packages:
```
sudo apt update -y
```


1. Install needed packages:
```
sudo apt install net-tools cifs-utils
```

2. Mount the Windows network using the "drvfs".

```
sudo mkdir /mnt/tierra
```

Add into the "/etc/fstab" to be permanent.

```
sudo vim /etc/fstab
```
```
//tierra.cnic.es/sc     /mnt/tierra     drvfs   credentials=/root/creds_smb_library_core,uid=jmrodriguezc,guid=jmrodriguezc     0 0
```

3. Create the credentials file
```
sudo vim /root/creds_smb_library_core
```

```
username=CNIC/jmrodriguezc
password=XXXXXXXXX
```

4. Mount all
```
sudo mount -a
```
<!--
sudo apt install samba-common samba smbclient

smbclient //tierra.cnic.es/SC --user=CNIC/jmrodriguezc

sudo mount.cifs //tierra.cnic.es/SC /mnt/tierra -o user=CNIC/jmrodriguezc
sudo mount -t cifs //tierra.cnic.es/SC /mnt/tierra -o user=CNIC/jmrodriguezc
 -->



# Install Singularity

## Install system dependencies
You must first install development tools and libraries to your host.

On Debian-based systems, including Ubuntu:


```
sudo apt-get update
sudo apt-get install -y \
    autoconf \
    automake \
    cryptsetup \
    fuse2fs \
    git \
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
    wget \
    zlib1g-dev
```

## Install Go
SingularityCE is written in Go, and may require a newer version of Go than is available in the repositories of your distribution. We recommend installing the latest version of Go from the official binaries (https://golang.org/dl/)

```
export VERSION=1.22.1 OS=linux ARCH=amd64 && \
  cd /tmp && \
  wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && \
  sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && \
  rm go$VERSION.$OS-$ARCH.tar.gz
```

Set the Environment variable PATH to point to Go:
```
echo 'export PATH=/usr/local/go/bin:${PATH}' >> ~/.bashrc
source ~/.bashrc
```

## Download SingularityCE from a release
You can download SingularityCE from one of the releases. To see a full list, visit the GitHub release page (https://github.com/sylabs/singularity/releases).

After deciding on a release to install, you can run the following commands to proceed with the installation.
```
cd ${HOME}/softwares
export VERSION=4.1.2 && \
  wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-ce-${VERSION}.tar.gz
  tar -xzf singularity-ce-${VERSION}.tar.gz && \
  cd singularity-ce-${VERSION}
```

## Compile the SingularityCE source code
Now you are ready to build SingularityCE. Dependencies will be automatically downloaded. You can build SingularityCE using the following commands:
```
./mconfig && \
  make -C builddir && \
  sudo make -C builddir install
```


## Using singularity run from within the Docker container
**It is strongly recommended that you don't use the Docker container for running Singularity images**, only for creating them, since the Singularity command runs within the container as the root user.

However, for the purposes of this simple example, and potentially for testing/debugging purposes it is useful to know how to run a Singularity container within the Docker Singularity container. You may recall from the Running a container from the image section in the previous episode that we used the --contain switch with the singularity command. If you don’t use this switch, it is likely that you will get an error relating to /etc/localtime similar to the following:
```
WARNING: skipping mount of /etc/localtime: no such file or directory
FATAL:   container creation failed: mount /etc/localtime->/etc/localtime error: while mounting /etc/localtime: mount source /etc/localtime doesn't exist
```
This occurs because the /etc/localtime file that provides timezone configuration is not present within the Docker container. If you want to use the Docker container to test that your newly created image runs, you can use the --contain switch, or you can open a shell in the Docker container and add a timezone configuration as described in the Alpine Linux documentation:

```
sudo apt-get install tzdata
sudo cp /usr/share/zoneinfo/Europe/Madrid /etc/localtime
```
The singularity run command should now work successfully without needing to use --contain. Bear in mind that once you exit the Docker Singularity container shell and shutdown the container, this configuration will not persist.


# Install Nextflow

## Check prerequisites

Make sure 11 or later is installed on your computer by using the command:
```
java -version
```
Otherwise:
```
sudo apt install openjdk-21-jre-headless
  or
sudo apt install openjdk-19-jre-headless
```

## Set up
Dead easy to install

Enter this command in your terminal:
```
mkdir -p ~/softwares/nextflow && \
cd ~/softwares/nextflow && \
curl -s https://get.nextflow.io | bash
```
(it creates a file nextflow in a bin folder in your home)

Set the Environment variable PATH to point to ~/bin:
```
echo 'export PATH=~/softwares/nextflow:$PATH' >> ~/.bashrc && \
  source ~/.bashrc
```


# Install SGE in Ubuntu

https://svennd.be/SGE_on_Ubuntu_20.04_LTS/


# Docker compose

Common Docker Compose Commands with a Specific File
Here are some common Docker Compose commands using a specific file:

- Start services:
```
docker-compose -f docker-compose.dev.yml up
```

- Start services in detached mode:
```
docker-compose -f docker-compose.dev.yml up -d
```

- Stop services:
```
docker-compose -f docker-compose.dev.yml down
```

- Build services:
```
docker-compose -f docker-compose.dev.yml build
```

- View logs:
```
docker-compose -f docker-compose.dev.yml logs
```

- List running services:
```
docker-compose -f docker-compose.dev.yml ps
```

- Execute a command in a running service:
```
docker-compose -f docker-compose.dev.yml exec app sh
```
