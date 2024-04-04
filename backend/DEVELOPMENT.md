# Install Docker Desktop on Windows
------------------------------

Reference: https://docs.docker.com/desktop/install/windows-install/


# Build the image of Nextflow core
------------------------------
Now that you have your Dockerfile, you can build your image. The docker build command does the heavy-lifting of creating a docker image from a Dockerfile.

Open Windows Prompt:
```
cd S:\U_Proteomica\UNIDAD\DatosCrudos\jmrodriguezc\projects\quantMS-PTM\backend\docker\build

docker build -t backend -f backend.Dockerfile .
```
<!-- DEPRECATED
```
cd build/nextflow
docker build -t nextflow -f nextflow.Dockerfile .

cd build/search_engine
docker build -t search_engine -f search_engine.Dockerfile .

cd build/refrag
docker build -t refrag -f refrag.Dockerfile .

cd build/shifts
docker build -t shifts -f shifts.Dockerfile .

cd build/solver
docker build -t solver -f solver.Dockerfile .

``` -->

Create volume
```
docker volume create --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc\U_Proteomica\UNIDAD\DatosCrudos\jmrodriguezc\projects\ --opt o=addr=tierra.cnic.es,domain=CNIC,username=jmrodriguezc,password="JaDe20-33!;" --name tierra

docker volume create --driver local --name workspace
```

<!-- DEPRECATED
```
docker volume create --driver local --name opt
``` -->

Run the nextflow contaniner
```
docker run --name backend -it -v tierra:/mnt/tierra  -v workspace:/workspace -p 8080:8080 backend
```

<!-- DEPRECATED
```
docker run --name search_engine -it -v tierra:/mnt/tierra search_engine

docker run --name refrag -it -v tierra:/mnt/tierra refrag

docker run --name shifts -it -v tierra:/mnt/tierra shifts

docker run --name solver -it -v tierra:/mnt/tierra solver
``` -->

Run the nextflow contaniner with privileged but **Be Carefull!!**
```
docker run --security-opt seccomp=unconfined --name nextflow -it -v tierra:/mnt/tierra nextflow
docker run --privileged --name nextflow -it -v tierra:/mnt/tierra nextflow
```
References:
    Why is python slower inside a docker container?
    https://stackoverflow.com/questions/76130370/why-is-python-slower-inside-a-docker-container/76133102#76133102

    Why A Privileged Container in Docker Is a Bad Idea
    https://www.trendmicro.com/en_sg/research/19/l/why-running-a-privileged-container-in-docker-is-a-bad-idea.html


Exec a shell of container that already exists
```
docker exec -it nextflow bash
```

__

Start the nextflow container
```
docker start nextflow
```



Remove a container
```
docker rm nextflow
```

Remove an image
```
docker rmi nextflow
```


# Compose PTM-compass project
-------------------------

From your project directory, start up your application by running
```
docker-compose up
```

Run the ptm-compass service
```
docker compose run ptm-compass
```






# TESTING ---




Run the nextflow contaniner
```
docker run --name nextflow -it nextflow

docker run --name nextflow -it --volume S:\U_Proteomica\UNIDAD:/mnt/tierra nextflow

docker run --name nextflow -it --volume \\tierra.cnic.es\SC:/mnt/tierra nextflow


docker run --name nextflow -it -v //tierra.cnic.es/SC:/mnt/tierra nextflow

docker run --name nextflow -it -v C:\Users\jmrodriguezc:/mnt/tierra nextflow


""


docker run --name nextflow --mount type=bind,source="S:\U_Proteomica\UNIDAD"/target,target=/mnt/tierra nextflow

docker run --name nextflow --mount type=bind,source="S:\U_Proteomica\UNIDAD"/target,target=/mnt/tierra nextflow

docker run --name nextflow --mount type=bind,source="\\tierra.cnic.es\SC"/target,target=/mnt/tierra -it nextflow 


docker run --name nextflow --mount type=bind,source="\\tierra.cnic.es\SC"/target,target=/mnt/tierra -it nextflow 

docker run --name nextflow -it nextflow --mount type=bind,source="\\tierra.cnic.es\SC"/target,target=/mnt/tierra


docker volume create \
	--driver local \
	--opt type=cifs \
	--opt device=//uxxxxx.your-server.de/backup \
	--opt o=addr=uxxxxx.your-server.de,username=uxxxxxxx,password=*****,file_mode=0777,dir_mode=0777 \
	--name cif-volume


docker volume create --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=addr=tierra.cnic.es,username=CNIC/jmrodriguezc,password=JaDe20-32!;,file_mode=0777,dir_mode=0777 --name tierra2

docker volume create --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=addr=tierra.cnic.es,domain=CNIC,username=jmrodriguezc,password="JaDe20-32!;" --name tierra

docker volume create --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=addr=tierra.cnic.es,credentials="S:\U_Proteomica\UNIDAD\DatosCrudos\jmrodriguezc\projects\PTMs_nextflow\docker\build\creds_smb_library",vers=3.0 --name tierra4


docker volume create --driver local --opt type=cifs --opt device=//tierra.cnic.es/sc --opt o=addr=tierra.cnic.es,username=CNIC/jmrodriguezc,password=JaDe20-32!;,file_mode=0777,dir_mode=0777 --name tierra

docker volume create --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=addr=tierra.cnic.es,credentials="S:\U_Proteomica\UNIDAD\DatosCrudos\jmrodriguezc\projects\PTMs_nextflow\docker\build\creds_smb_library" --name tierra

docker volume create --driver local --opt type=cifs --opt device="\\\\tierra.cnic.es\\sc" --opt o=addr=tierra.cnic.es,username=CNIC/jmrodriguezc,password=JaDe20-32!; --name tierra2

docker volume create --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=addr=tierra.cnic.es,username=CNIC/jmrodriguezc,password=JaDe20-32!;,file_mode=0777,dir_mode=0777 --name tierra2

docker volume create --driver local --name persistent --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=vers=3.0,credentials="S:\U_Proteomica\UNIDAD\DatosCrudos\jmrodriguezc\projects\PTMs_nextflow\docker\build\creds_smb_library" --name tierra3

docker volume create --driver local --name persistent --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=credentials="S:\U_Proteomica\UNIDAD\DatosCrudos\jmrodriguezc\projects\PTMs_nextflow\docker\build\creds_smb_library" --name tierra

docker volume create --driver local --name persistent --opt type=cifs --opt device=\\tierra.cnic.es\sc --opt o=vers=3.0,credentials=/root/creds_smb_library --name tierra3



docker run -d --name nextflow --mount source=tierra,target=/mnt/tierra nextflow 

docker run -d --name nextflow --mount source=tierra2,target=/mnt/tierra nextflow



$ docker service create \
    --mount 'type=volume,src=<VOLUME-NAME>,dst=<CONTAINER-PATH>,volume-driver=local,volume-opt=type=nfs,volume-opt=device=<nfs-server>:<nfs-path>,"volume-opt=o=addr=<nfs-address>,vers=4,soft,timeo=180,bg,tcp,rw"'
    --name myservice \
    <IMAGE>

$ docker service create \
    --mount 'type=volume,src=cif-volume,dst=/mnt/tierra,volume-driver=local,volume-opt=type=cifs,volume-opt=device=<nfs-server>:<nfs-path>,"volume-opt=o=addr=<nfs-address>,vers=4,soft,timeo=180,bg,tcp,rw"'
    --name myservice \
    nextflow






Note: When you "run" nextflow, you can decide how many process to use?? Or not...



Get all the drives in windows (cmd)???
```
wmic logicaldisk get caption
```