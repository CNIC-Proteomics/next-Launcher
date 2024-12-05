# Working in development mode


## Docker compose for development

Common Docker Compose Commands with a Specific File
Here are some common Docker Compose commands using a specific file:

+ Open Windows Prompt
```
cd S:\U_Proteomica\UNIDAD\Softwares\jmrodriguezc\next-Launcher
s:
```

+ Build services
```
docker-compose --env-file .env_cnic_dev -f docker-compose.cnic_dev.yml build --no-cache
```

+ Start service
```
docker-compose --env-file .env_cnic_dev -f docker-compose.cnic_dev.yml up -d
```

## Push images to DockerHub

1. Build services
```
docker-compose --env-file .env_cnic_dev -f docker-compose.cnic_dev.yml build --no-cache
```

2. Authenticating
```
docker login -u proteomicscnic
    Authenticating with existing credentials...
```

3. Tag the the image
```
docker image tag proteomicscnic/next-launcher-core:latest proteomicscnic/next-launcher-core:0.1.3
docker image tag proteomicscnic/next-launcher-app:latest  proteomicscnic/next-launcher-app:0.1.3
```

4. Push the images
```
docker push proteomicscnic/next-launcher-core:0.1.3
docker push proteomicscnic/next-launcher-app:0.1.3
```


# Working in production mode

## Docker compose

Common Docker Compose Commands with a Specific File
Here are some common Docker Compose commands using a specific file:

+ Compose services
```
docker-compose --env-file .env_cnic -f docker-compose.cnic.yml up -d
```





______________________________


# BACKEND

---


# Working in development mode


## Create a user-defined bridge network

```
docker network create next-launcher-network_dev
```


## Create volumes in Docker

Create workspace volumes (production and development) for the Nextflow pipelines in the container:
```
docker volume create --name workspace --driver local
```

Workspace for production and development created on the D disk:
```
docker volume create --name workspace --driver local --opt type=none --opt device=D:\\next-Launcher\\workspace --opt o=bind
```

Create the 'tierra' volumes for the connection with the container:
```
docker volume create --name lab --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc\LAB_JVC\ --opt o=addr=tierra.cnic.es,domain=CNIC,username=jmrodriguezc,password="JaDe20-34!;"
docker volume create --name unit --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc\U_Proteomica\ --opt o=addr=tierra.cnic.es,domain=CNIC,username=jmrodriguezc,password="JaDe20-34!;"
```


## Create MongoDB in Docker

+ Edit the '.env' file using '.env_cnic' template

+ Build MongoDB core (Docker image)

Now that you have your Dockerfile, you can build your image. The docker build command does the heavy-lifting of creating a docker image from a Dockerfile.

Open Windows Prompt
```
cd S:\U_Proteomica\UNIDAD\Softwares\jmrodriguezc\next-Launcher
s:
@echo off & for /f "tokens=1,2 delims==" %i in (.env_cnic_dev) do set %i=%j
docker build ^
  --no-cache ^
  --build-arg MONGODB_HOST=%MONGODB_HOST% ^
  --build-arg MONGODB_PORT=%MONGODB_PORT% ^
  --build-arg MONGODB_USER=%MONGODB_USER% ^
  --build-arg MONGODB_PWD=%MONGODB_PWD% ^
  -t proteomicscnic/next-launcher-db:latest ^
  -f backend/build/mongodb.Dockerfile  .
@echo on
```
Load the env variables from the '.env' file and build the image

+ Run the MongoDB contaniner
```
@echo off & for /f "tokens=1,2 delims==" %i in (.env_cnic_dev) do set %i=%j
docker run -d ^
  --name next-launcher-db_dev ^
  --network next-launcher-network_dev ^
  -p %MONGODB_PORT%:%MONGODB_PORT% ^
  proteomicscnic/next-launcher-db:latest
@echo on
```

+ Start the MongoDB contaniner (if the container was already created)
```
docker start next-launcher-db_dev
```

+ Execute MongoDB container
```
docker exec -it next-launcher-db_dev bash
```


## Create next-Launcher-core in Docker

+ Build next-Launcher core

Now that you have your Dockerfile, you can build your image. The docker build command does the heavy-lifting of creating a docker image from a Dockerfile.

Open Windows Prompt
```
cd S:\U_Proteomica\UNIDAD\Softwares\jmrodriguezc\next-Launcher
s:
@echo off & for /f "tokens=1,2 delims==" %i in (.env_cnic_dev) do set %i=%j
docker build ^
  --no-cache ^
  --build-arg HOST_IP=%HOST_IP% ^
  --build-arg PORT_CORE=%PORT_CORE% ^
  --build-arg PORT_APP=%PORT_APP% ^
  ^
  --build-arg MONGODB_HOST=%MONGODB_HOST% ^
  --build-arg MONGODB_USER=%MONGODB_USER% ^
  --build-arg MONGODB_PWD=%MONGODB_PWD% ^
  --build-arg MONGODB_DB=%MONGODB_DB% ^
  ^
  --build-arg USER_GUEST=%USER_GUEST% ^
  --build-arg PWD_GUEST=%PWD_GUEST% ^
  ^
  --build-arg USER_ADMIN=%USER_ADMIN% ^
  --build-arg PWD_ADMIN=%PWD_ADMIN% ^
  ^
  --build-arg SHARED_VOLUMES=%SHARED_VOLUMES% ^
  ^
  -t proteomicscnic/next-launcher-core:latest ^
  -f backend/build/backend.Dockerfile  backend/build/.
@echo on
```
Load the env variables from the '.env' file and build the image

Open Linux shell
```
export $(grep -v '^#' .env_cnic_dev | xargs)
docker build \
  --no-cache \
  --build-arg HOST_IP=${HOST_IP} \
  --build-arg PORT_CORE=${PORT_CORE} \
  --build-arg PORT_APP=${PORT_APP} \
  \
  --build-arg MONGODB_HOST=${MONGODB_HOST} \
  --build-arg MONGODB_USER=${MONGODB_USER} \
  --build-arg MONGODB_PWD=${MONGODB_PWD} \
  --build-arg MONGODB_DB=${MONGODB_DB} \
  \
  --build-arg USER_GUEST=${USER_GUEST} \
  --build-arg PWD_GUEST=${PWD_GUEST} \
  \
  --build-arg USER_ADMIN=${USER_ADMIN} \
  --build-arg PWD_ADMIN=${PWD_ADMIN} \
  \
  --build-arg SHARED_VOLUMES=${SHARED_VOLUMES} \
  \
  -t proteomicscnic/next-launcher-core:latest \
  -f backend/build/backend.Dockerfile  backend/build/.
```

+ Run the contaniner

Run the next-launcher core container adding the volumenes, ports, and link to mongodb container
```
@echo off & for /f "tokens=1,2 delims==" %i in (.env_cnic_dev) do set %i=%j
docker run ^
  -it ^
  --name next-launcher-core_dev ^
  --network next-launcher-network_dev ^
  --link next-launcher-db_dev:mongo ^
  -v %SHARED_VOLUME_1% ^
  -v %SHARED_VOLUME_2% ^
  -v %SHARED_VOLUME_3% ^
  -p %PORT_CORE%:%PORT_CORE% ^
  proteomicscnic/next-launcher-core:latest
```

+ Start the contaniner

In the case the container has been already created but it is not started... Start the nextflow container
```
docker start next-launcher-core_dev
```

+ Execute the container

Exec a shell of container that already exists
```
docker exec -it next-launcher-core_dev bash
```


______________________________

# FRONTEND

---

# Working in production mode

## Docker compose for development
...

## Push images to DockerHub

1. Authenticating
```
docker login -u proteomicscnic
    Authenticating with existing credentials...
```

2. Tag the the image
```
docker image tag proteomicscnic/next-launcher-app:latest proteomicscnic/next-launcher-app:0.1.2
```

2. Push the images
```
docker push proteomicscnic/next-launcher-app:0.1.2
```


# Working in development mode

## Create next-Launcher-app in Docker

+ Build next-Launcher app

Now that you have your Dockerfile, you can build your image. The docker build command does the heavy-lifting of creating a docker image from a Dockerfile.

Open Windows Prompt
```
cd S:\U_Proteomica\UNIDAD\Softwares\jmrodriguezc\next-Launcher
s:
@echo off & for /f "tokens=1,2 delims==" %i in (.env_cnic_dev) do set %i=%j
docker build ^
  --no-cache ^
  --build-arg HOST_IP=%HOST_IP% ^
  --build-arg PORT_CORE=%PORT_CORE% ^
  --build-arg PORT_APP=%PORT_APP% ^
  ^
  --build-arg SHARED_VOLUMES=%SHARED_VOLUMES% ^
  ^
  -t proteomicscnic/next-launcher-app:latest ^
  -f frontend/build/frontend.Dockerfile  frontend/build/.
@echo on
```

+ Run the contaniner

```
@echo off & for /f "tokens=1,2 delims==" %i in (.env_cnic_dev) do set %i=%j
docker run -it ^
  --name next-launcher-app_dev ^
  -v %SHARED_VOLUME_1% ^
  -p %PORT_APP%:%PORT_APP% ^
  proteomicscnic/next-launcher-app:latest
```

+ Execute the container

Exec a shell of container that already exists
```
docker exec -it next-launcher-app_dev bash
```

In the case the container has been already created but it is not started... Start the nextflow container
```
docker start next-launcher-app_dev
```









______________________________

FOR MORE INFORMATION:


## Create volumes in Docker

Create workspace volumes (production and development) for the Nextflow pipelines in the container:
```
docker volume create --name workspace --driver local
docker volume create --name workspace_dev --driver local
```

Workspace for production and development created on the D disk:
```
docker volume create --name workspace --driver local --opt type=none --opt device=D:\\next-Launcher\\production --opt o=bind
docker volume create --name workspace_dev --driver local --opt type=none --opt device=D:\\next-Launcher\\development --opt o=bind
```

Create the 'tierra' volume for the connection with the container:
```
docker volume create --name tierra --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc\ --opt o=addr=tierra.cnic.es,domain=CNIC,username=jmrodriguezc,password="JaDe20-34!;"
```


<!-- THIS DOES NOT WORK... ASK EDU IF I CAN CREATE SYMBOLIC LINK -->
<!-- docker volume create --name workspace --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc\U_Proteomica\UNIDAD\DatosCrudos\next-Launcher\ --opt o=addr=tierra.cnic.es,domain=CNIC,username=jmrodriguezc,password="JaDe20-34!;" -->
<!-- docker volume create --name tierra --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc\U_Proteomica\UNIDAD\Softwares\jmrodriguezc\ --opt o=addr=tierra.cnic.es,domain=CNIC,username=jmrodriguezc,password="JaDe20-34!;" -->




## Run the Docker contaniner

Run the next-launcher core container:
```
docker run --name next-launcher-core -it -v workspace_dev:/workspace -v tierra:/mnt/tierra -p 8081:8081 proteomicscnic/next-launcher-core:latest
```

Run the nextflow contaniner with privileged but **Be Carefull!!**
```
docker run --security-opt seccomp=unconfined --name backend -it -v tierra:/mnt/tierra backend
docker run --privileged --name backend -it -v tierra:/mnt/tierra backend
```

export PORT_CORE=8081 && export HOST_IP=localhost && export PORT_APP=3031 && ./scripts/startup-local.sh mongo
cd /opt/nextflow-api/
cp -r /mnt/tierra/U_Proteomica/UNIDAD/Softwares/jmrodriguezc/nextflow-api/bin/backend.py bin/backend.py


<!--
References:
    Why is python slower inside a docker container?
    https://stackoverflow.com/questions/76130370/why-is-python-slower-inside-a-docker-container/76133102#76133102

    Why A Privileged Container in Docker Is a Bad Idea
    https://www.trendmicro.com/en_sg/research/19/l/why-running-a-privileged-container-in-docker-is-a-bad-idea.html
 -->



Remove a container
```
docker rm next-launcher-core
```

Remove an image
```
docker rmi proteomicscnic/next-launcher-core:latest
```



<!-- 

# TESTING ---




Run the nextflow contaniner
```
docker run --name backend -it backend

docker run --name backend -it --volume S:\U_Proteomica\UNIDAD:/mnt/tierra backend

docker run --name backend -it --volume \\tierra.cnic.es\SC:/mnt/tierra backend


docker run --name backend -it -v //tierra.cnic.es/SC:/mnt/tierra backend

docker run --name backend -it -v C:\Users\jmrodriguezc:/mnt/tierra backend


""


docker run --name backend --mount type=bind,source="S:\U_Proteomica\UNIDAD"/target,target=/mnt/tierra backend

docker run --name backend --mount type=bind,source="S:\U_Proteomica\UNIDAD"/target,target=/mnt/tierra backend

docker run --name backend --mount type=bind,source="\\tierra.cnic.es\SC"/target,target=/mnt/tierra -it backend 


docker run --name backend --mount type=bind,source="\\tierra.cnic.es\SC"/target,target=/mnt/tierra -it backend 

docker run --name backend -it backend --mount type=bind,source="\\tierra.cnic.es\SC"/target,target=/mnt/tierra


docker volume create \
	--driver local \
	--opt type=cifs \
	--opt device=//uxxxxx.your-server.de/backup \
	--opt o=addr=uxxxxx.your-server.de,username=uxxxxxxx,password=*****,file_mode=0777,dir_mode=0777 \
	--name cif-volume


docker volume create --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=addr=tierra.cnic.es,username=CNIC/jmrodriguezc,password=JaDe20-32!;,file_mode=0777,dir_mode=0777 --name tierra2

docker volume create --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=addr=tierra.cnic.es,domain=CNIC,username=jmrodriguezc,password="JaDe20-32!;" --name tierra

docker volume create --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=addr=tierra.cnic.es,credentials="S:\U_Proteomica\UNIDAD\Softwares\jmrodriguezc\PTMs_nextflow\docker\build\creds_smb_library",vers=3.0 --name tierra4


docker volume create --driver local --opt type=cifs --opt device=//tierra.cnic.es/sc --opt o=addr=tierra.cnic.es,username=CNIC/jmrodriguezc,password=JaDe20-32!;,file_mode=0777,dir_mode=0777 --name tierra

docker volume create --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=addr=tierra.cnic.es,credentials="S:\U_Proteomica\UNIDAD\Softwares\jmrodriguezc\PTMs_nextflow\docker\build\creds_smb_library" --name tierra

docker volume create --driver local --opt type=cifs --opt device="\\\\tierra.cnic.es\\sc" --opt o=addr=tierra.cnic.es,username=CNIC/jmrodriguezc,password=JaDe20-32!; --name tierra2

docker volume create --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=addr=tierra.cnic.es,username=CNIC/jmrodriguezc,password=JaDe20-32!;,file_mode=0777,dir_mode=0777 --name tierra2

docker volume create --driver local --name persistent --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=vers=3.0,credentials="S:\U_Proteomica\UNIDAD\Softwares\jmrodriguezc\PTMs_nextflow\docker\build\creds_smb_library" --name tierra3

docker volume create --driver local --name persistent --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=credentials="S:\U_Proteomica\UNIDAD\Softwares\jmrodriguezc\PTMs_nextflow\docker\build\creds_smb_library" --name tierra

docker volume create --driver local --name persistent --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=vers=3.0,credentials=/root/creds_smb_library --name tierra3



docker run -d --name backend --mount source=tierra,target=/mnt/tierra backend 

docker run -d --name backend --mount source=tierra2,target=/mnt/tierra backend



$ docker service create \
    --mount 'type=volume,src=<VOLUME-NAME>,dst=<CONTAINER-PATH>,volume-driver=local,volume-opt=type=nfs,volume-opt=device=<nfs-server>:<nfs-path>,"volume-opt=o=addr=<nfs-address>,vers=4,soft,timeo=180,bg,tcp,rw"'
    --name myservice \
    <IMAGE>

$ docker service create \
    --mount 'type=volume,src=cif-volume,dst=/mnt/tierra,volume-driver=local,volume-opt=type=cifs,volume-opt=device=<nfs-server>:<nfs-path>,"volume-opt=o=addr=<nfs-address>,vers=4,soft,timeo=180,bg,tcp,rw"'
    --name myservice \
    backend






Note: When you "run" nextflow, you can decide how many process to use?? Or not...



Get all the drives in windows (cmd)???
```
wmic logicaldisk get caption
```

-->