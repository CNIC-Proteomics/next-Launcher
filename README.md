# next-Launcher

next-Laucher is a system that execute Nextflow pipelines

Core for the next-Launcher: backend and frontend systems

Quantitative Mass Spectrometry and Post-Translational Modifications analysis workflow.

# Installation

## Prerequisites
Before you begin, ensure you have met the following requirements:

- You have **Docker Desktop**, that is a platform designed to help developers build, share, and run container applications.

For further information on how to install Docker, visit the official website: https://www.docker.com

### Install Docker Desktop on Windows

This following page contains the information about system requirements, and instructions on how to install Docker Desktop for Windows:
https://docs.docker.com/desktop/install/windows-install/


### Install Docker Desktop on Mac

This following page contains the information about system requirements, and instructions on how to install Docker Desktop for Mac:
https://docs.docker.com/desktop/install/mac-install/


<!-- 
- Git, git-LFS??
- Make??
- Docker engine

Install Make on Windows????

Directly download from Make for Windows:
https://gnuwin32.sourceforge.net/packages/make.htm
 -->


## Installation

Modify **.env** file

```
docker compose up
```

# Version history

| Version | Description                  | Docker images                                                                        			                          | Software                    | Version |
|---------|------------------------------|----------------------------------------------------------------------------------------------------------------------|-----------------------------|---------|
| 0.1.0   | First stable version         |                                                                                                                      |                             |         |
|         |                              | [proteomicscnic/next-launcher-core:0.1.0](https://cloud.sylabs.io/library/proteomicscnic/next-launcher/ptm-compass)	|                             |         |
|         |                              |                                                                                                                      | Nextflow                    | 23.10.1 |
|         |                              |                                                                                                                      | Nextflow-API                | 1.0     |
|         |                              |                                                                                                                      | MSFragger                   | 3.8     |
|         |                              |                                                                                                                      | ThermoRawFileParser         | 1.4.2   |
|         |                              |                                                                                                                      | bioDataHub (DecoyPYrat)     | 2.13    |
|         |                              |                                                                                                                      | MZ_extractor                | 1.0     |
|         |                              |                                                                                                                      | RefMod                      | 0.4.3   |
|         |                              |                                                                                                                      | SHIFTS                      | 0.4.3   |
|         |                              |                                                                                                                      | SOLVER                      | 1.0     |
|         |                              | [proteomicscnic/next-launcher-app:0.1.0](https://cloud.sylabs.io/library/proteomicscnic/next-launcher/ptm-compass)	  |                             |         |
|         |                              |                                                                                                                      | next-Launcher-app           | 0.1.0   |
