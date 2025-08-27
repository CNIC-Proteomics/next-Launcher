___
## 0.1.6

### Date 📅 *2025_08*

### Changes in the detail

**rc1**
+ Centralized MongoDB Access: Instead of running a separate MongoDB instance on each computer, the system now uses a single shared MongoDB instance for the Next-Launcher.
  - Run MongoDB on a single host using a Docker container.
  - Allow other machines to connect to MongoDB by binding the container to the host IP (using MONGODB_HOST and MONGODB_IP).
  - All other machines simply connect to this centralized MongoDB instance.
+ Refined the time parameter for process executions.

**rc2**
+ Rename the env variable HOST_IP to HOST_NAME.
+ Include the host name in the workflow report and in the workflow meta file.
+ Display the summary log correctly in the workflow trace log.

**rc3**
+ Discarded the subfolder in the workflow results.
+ Added the singularity options into backend/nextflow/conf/nextflow.config.
+ Included the singularity info (image library) in pipeline json files.
+ Updated backend.Dockerfile to install Singularity and remove deprecated packages.
+ Added the NXF_SINGULARITY_CACHEDIR and NXF_PIPELINES env variables into backend.Dockerfile.

**rc4**
+ Renamed folder that stores Singularity images.
+ Updated mount points for new volume locations.
+ Updated pipelines to newer versions.

**rc5**
+ Fix bugs during migration to production.

### Repositories Version History

+ Updated to the new version. Now only Nextflow, Singularity, and Nextflow API are installed:
  - next-Launcher-app 0.1.6
  - nextflow-api 1.6
  - go 1.22.1
  - Singularity 4.1.2

| Docker images                                                                                                                   | Software                    | Version   |
|---------------------------------------------------------------------------------------------------------------------------------|-----------------------------|-----------|
| [proteomicscnic/next-launcher-core:0.1.6](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-core/general)   |                             |           |
|                                                                                                                                 | Nextflow                    | >=24.10.5 |
|                                                                                                                                 | nextflow-api                | 1.6       |
|                                                                                                                                 | Singularity                 | 4.1.2     |
|                                                                                                                                 | go                          | 1.22.1    |
| [proteomicscnic/next-launcher-app:0.1.6](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-app/general)	    |                             |           |
|                                                                                                                                 | next-Launcher-app           | 0.1.6     |



___
## 0.1.5

### Date 📅 *2025_04*

### Changes in the detail

+ Create a dedicated Docker image named **next-launcher-db** for the next-Launcher.  
+ Add a volume to persist database data.  
+ Add a volume containing the pipelines displayed in the frontend application.  
+ Introduce a new volume for output results, named **outspace**.  
+ The **base.config** file is now deprecated.
+ Create a local workspace for the next-Launcher production (version out of CNIC).

### Repositories Version History

| Docker images                                                                                                                   | Software                    | Version   |
|---------------------------------------------------------------------------------------------------------------------------------|-----------------------------|-----------|
| [proteomicscnic/next-launcher-core:0.1.5](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-core/general)   |                             |           |
|                                                                                                                                 | Nextflow                    | >=24.10.5 |
|                                                                                                                                 | nextflow-api                | 1.5       |
|                                                                                                                                 | MSFragger                   | 4.2-rc14  |
|                                                                                                                                 | ThermoRawFileParser         | 1.4.5     |
|                                                                                                                                 | bioDataHub (DecoyPYrat)     | 2.14      |
|                                                                                                                                 | SearchToolkit               | 1.3       |
|                                                                                                                                 | PTM-compass                 | 1.4       |
|                                                                                                                                 | REFMOD                      | 0.4.5     |
|                                                                                                                                 | PTM-Analyzer                | v1.04     |
| [proteomicscnic/next-launcher-app:0.1.5](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-app/general)	    |                             |           |
|                                                                                                                                 | next-Launcher-app           | 0.1.5     |


___
## 0.1.4
```
DATE: 2024_12
```

### Highlights

+ Upgrade versions.

### Changes in the Backend (next-launcher-core)

+ Fixing a bug creating the global output.

### Changes in the Frontend (next-launcher-app)


### Version history

| Docker images                                                                                                                   | Software                    | Version  |
|---------------------------------------------------------------------------------------------------------------------------------|-----------------------------|----------|
| [proteomicscnic/next-launcher-core:0.1.4](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-core/general)   | Nextflow                    | 23.10.1  |
|                                                                                                                                 | MSFragger                   | 4.2-rc14 |
|                                                                                                                                 | ThermoRawFileParser         | 1.4.5    |
|                                                                                                                                 | bioDataHub (DecoyPYrat)     | 2.13     |
|                                                                                                                                 | SearchToolkit               | 1.2      |
|                                                                                                                                 | PTM-compass                 | 1.2      |
|                                                                                                                                 | RefMod                      | 0.4.4    |
|                                                                                                                                 | nextflow-api                | 1.3      |
| [proteomicscnic/next-launcher-app:0.1.4](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-app/general)	    | next-Launcher-app           | 0.1.4    |



___
## 0.1.3
```
DATE: 2024_12
```

### Highlights

+ Add dataset components.
+ Add shared volumes.
+ Improve the installation.

### Changes in the Backend (next-launcher-core)

+ Fixing a bug in the MongoDB port.

+ nextflow-api:
  - Changes for the dataset reports: remove files, add 'name' metadata, ...
  - Exception logs are printed by standard output.

+ Create REST API to handle the shared volumes

### Changes in the Frontend (next-launcher-app)

+ next-Launcher-app:
  - Add Dataset components
  - Create Web interface to handle the Shared volumes from the REST API.

### Version history

| Docker images                                                                                                                   | Software                    | Version |
|---------------------------------------------------------------------------------------------------------------------------------|-----------------------------|---------|
| [proteomicscnic/next-launcher-core:0.1.3](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-core/general)   | Nextflow                    | 23.10.1 |
|                                                                                                                                 | MSFragger                   | 4.1     |
|                                                                                                                                 | ThermoRawFileParser         | 1.4.2   |
|                                                                                                                                 | bioDataHub (DecoyPYrat)     | 2.13    |
|                                                                                                                                 | MZ_extractor                | 1.0     |
|                                                                                                                                 | PTM-compass                 | 1.1     |
|                                                                                                                                 | RefMod                      | 0.4.4   |
|                                                                                                                                 | nextflow-api                | 1.3     |
| [proteomicscnic/next-launcher-app:0.1.3](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-app/general)	    | next-Launcher-app           | 0.1.3   |


___
## 0.1.2
```
DATE: 2024_08
```

### Highlights

+ Add the authentication

### Changes in the Backend (next-launcher-core)

+ nextflow-api:
  - Add the authentication
  - Add the MongoDB in remote mode

### Changes in the Frontend (next-launcher-app)

+ next-Launcher-app:
  - Add the authentication pages


### Version history

| Docker images                                                                                                                   | Software                    | Version |
|---------------------------------------------------------------------------------------------------------------------------------|-----------------------------|---------|
| [proteomicscnic/next-launcher-core:0.1.2](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-core/general)   | Nextflow                    | 23.10.1 |
|                                                                                                                                 | MSFragger                   | 3.8     |
|                                                                                                                                 | ThermoRawFileParser         | 1.4.2   |
|                                                                                                                                 | bioDataHub (DecoyPYrat)     | 2.13    |
|                                                                                                                                 | MZ_extractor                | 1.0     |
|                                                                                                                                 | RefMod                      | 0.4.3   |
|                                                                                                                                 | SHIFTS                      | 0.4.3   |
|                                                                                                                                 | SOLVER                      | 1.0     |
|                                                                                                                                 | nextflow-api                | 1.1     |
| [proteomicscnic/next-launcher-app:0.1.2](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-app/general)	    | next-Launcher-app           | 0.1.2   |


___
## 0.1.1
```
DATE: 2024_07
```

### Highlights

+ Really the first beta version.

### Changes in the Backend (next-launcher-core)


### Changes in the Frontend (next-launcher-app)

+ Fixing a bug in the nf-PTM-compass pipeline: ERROR ~ ERROR: Missing parameters: [refmod_files, recom_files]

### Version history

| Docker images                                                                                                                   | Software                    | Version |
|---------------------------------------------------------------------------------------------------------------------------------|-----------------------------|---------|
| [proteomicscnic/next-launcher-core:0.1.0](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-core/general)   | Nextflow                    | 23.10.1 |
|                                                                                                                                 | Nextflow-API                | 1.0     |
|                                                                                                                                 | MSFragger                   | 3.8     |
|                                                                                                                                 | ThermoRawFileParser         | 1.4.2   |
|                                                                                                                                 | bioDataHub (DecoyPYrat)     | 2.13    |
|                                                                                                                                 | MZ_extractor                | 1.0     |
|                                                                                                                                 | RefMod                      | 0.4.3   |
|                                                                                                                                 | SHIFTS                      | 0.4.3   |
|                                                                                                                                 | SOLVER                      | 1.0     |
| [proteomicscnic/next-launcher-app:0.1.1](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-app/general)	    | next-Launcher-app           | 0.1.1   |

___
## 0.1.0
```
DATE: 2024_07
```

### Highlights

+ Release the first beta version.

### Changes in the Backend (next-launcher-core)


### Changes in the Frontend (next-launcher-app)

### Version history

| Version | Docker images                                                                                                                   | Software                    | Version |
|---------|---------------------------------------------------------------------------------------------------------------------------------|-----------------------------|---------|
| 0.1.0   |                                                                                                                                 |                             |         |
|         | [proteomicscnic/next-launcher-core:0.1.0](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-core/general)	  |                             |         |
|         |                                                                                                                                 | Nextflow                    | 23.10.1 |
|         |                                                                                                                                 | Nextflow-API                | 1.0     |
|         |                                                                                                                                 | MSFragger                   | 3.8     |
|         |                                                                                                                                 | ThermoRawFileParser         | 1.4.2   |
|         |                                                                                                                                 | bioDataHub (DecoyPYrat)     | 2.13    |
|         |                                                                                                                                 | MZ_extractor                | 1.0     |
|         |                                                                                                                                 | RefMod                      | 0.4.3   |
|         |                                                                                                                                 | SHIFTS                      | 0.4.3   |
|         |                                                                                                                                 | SOLVER                      | 1.0     |
|         | [proteomicscnic/next-launcher-app:0.1.0](https://hub.docker.com/repository/docker/proteomicscnic/next-launcher-app/general)	    |                             |         |
|         |                                                                                                                                 | next-Launcher-app           | 0.1.0   |

___
## 0.0.X
```
DATE: 2024_XX
```

### Highlights

+ Developing the beta version

