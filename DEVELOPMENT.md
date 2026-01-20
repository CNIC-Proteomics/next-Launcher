# Working in production mode

## Docker compose

Common Docker Compose Commands with a Specific File
Here are some common Docker Compose commands using a specific file:

+ Open Windows Prompt
```
cd C:\Users\jmrodriguezc\next-Launcher
```

+ Start service
```
if [ "$MONGODB_HOST" = "HOST_NAME" ]; then
  docker-compose --env-file .env_cnic -f docker-compose.cnic.yml -f docker-compose.db.cnic.yml up -d
else
  docker-compose --env-file .env_cnic -f docker-compose.cnic.yml up -d
fi
```

+ Execute container in bash mode
```
docker exec -it next-launcher-core bash
```

<!--
+ Compose services depeding on the previous version or not
```
.\bin\start-up.bat .env_cnic docker-compose.cnic.yml
``` -->




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
if [ "$MONGODB_HOST" = "HOST_NAME" ]; then
  docker-compose --env-file .env_cnic_dev -f docker-compose.cnic_dev.yml -f docker-compose.db.cnic_dev.yml up -d
else
  docker-compose --env-file .env_cnic_dev -f docker-compose.cnic_dev.yml up -d
fi
```






## Push images to DockerHub

0. Open Windows Prompt
```
cd S:\U_Proteomica\UNIDAD\Softwares\jmrodriguezc\next-Launcher
s:
```

1. Export current version
```
set NL_VERSION=1.7
```

1. Build services
```
docker-compose --env-file .env_cnic_dev -f docker-compose.cnic_dev.yml build --no-cache
```

2. Authenticating
```
docker login -u proteomicscnic
    Authenticating with existing credentials...
```

3. Tag the the image. DEPRECATED
```
docker image tag proteomicscnic/next-launcher-core:latest proteomicscnic/next-launcher-core:%NL_VERSION%
docker image tag proteomicscnic/next-launcher-app:latest  proteomicscnic/next-launcher-app:%NL_VERSION%
```

4. Push the images
```
docker push proteomicscnic/next-launcher-core:%NL_VERSION%
docker push proteomicscnic/next-launcher-app:%NL_VERSION%
```








**FROM HERE IT IS ONLY OPTIONAL INFORMATION!!**


______________________________


# Commit huge files

**Requirements:** Download and install the Git command line extension. Once downloaded and installed, set up Git LFS for your user account by running:
```
git lfs install
```
You only need to run this once per user account.

1. Track the file:

In each Git repository where you want to use Git LFS, select the file types you'd like Git LFS to manage (or directly edit your .gitattributes). You can configure additional file extensions at anytime.
```
git lfs track backend/search_engine/MSFragger-4.2.zip
```

2. Add the changes in gitattributes:

Now make sure .gitattributes is tracked:
```
git add .gitattributes
```
Note that defining the file types Git LFS should track will not, by itself, convert any pre-existing files to Git LFS, such as files on other branches or in your prior commit history. To do that, use the git lfs migrate(1) command, which has a range of options designed to suit various potential use cases.

3. Add/Commit/Push the new huge file:

There is no step three. Just commit and push to GitHub as you normally would; for instance, if your current branch is named main:
```
git add -f backend/search_engine/MSFragger-4.2.zip
git commit -m "Add new MSFragger release"
git push origin main
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
docker volume create --name lab --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc\LAB_JVC\ --opt o=addr=tierra.cnic.es,domain=CNIC,username=jmrodriguezc,password=""
docker volume create --name unit --driver local --opt type=cifs --opt device=\\tierra.cnic.es\sc\U_Proteomica\ --opt o=addr=tierra.cnic.es,domain=CNIC,username=jmrodriguezc,password=""
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
  --build-arg HOST_NAME=%HOST_NAME% ^
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
  --build-arg HOST_NAME=${HOST_NAME} \
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
  --build-arg HOST_NAME=%HOST_NAME% ^
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


## Create a Git tag for your `release candidate` version.

## Recommended Flow

1. Develop features in feature branches.
2. Merge into `develop`.
3. When ready → create a **release branch**:

   ```bash
   git checkout -b release/v1.0.0 develop
   ```
4. Test, fix, stabilize.
```bash
git add .
git commit -m "feat(auth): implement JWT-based login"
```
5. Tag an **RC** (release candidate):

   ```bash
   git tag -a v1.0.0-rc1 -m "First release candidate for v1.0.0"
   git push origin v1.0.0-rc1
   ```
6. When approved → merge `release/v1.0.0` into `main`, create a **final tag**:

   ```bash
   git checkout main
   git merge release/v1.0.0
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin main --tags
   ```

---
**Best-practice Git workflow** for managing versions, releases, and release candidates using **commits** and **tags**. Let’s break it down step by step:
## 🔹 1. Commit Discipline

* Always commit **small, logical units of work**.
* Write clear commit messages (convention: **type(scope): short message**).

  * Examples:

    * `feat(api): add endpoint for peptide search`
    * `fix(db): correct SQL syntax in peptide insert`
    * `chore(ci): update GitHub Actions workflow`

Best practices:

```bash
git add .
git commit -m "feat(auth): implement JWT-based login"
```

## 🔹 2. Branching Strategy

Use branches to isolate work:

* **main / master** → always production-ready.
* **develop** → integration branch for new features.
* **feature/xxx** → for feature development.
* **hotfix/xxx** → for urgent bug fixes.

Example:

```bash
git checkout -b feature/add-search
# do work, commit
git push origin feature/add-search
```

## 🔹 3. Tags for Versioning

Git tags mark **specific commits** as versions.
Two main types:

* **Lightweight tags** → just a pointer (not recommended for releases).
* **Annotated tags** → includes metadata (best for releases).

### Create a release candidate tag:

```bash
git tag -a v1.0.0-rc1 -m "Release Candidate 1 for v1.0.0"
git push origin v1.0.0-rc1
```

### Create a final release tag:

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### 4. Semantic Versioning

Follow [SemVer](https://semver.org/):

* **MAJOR** → breaking changes (`v2.0.0`)
* **MINOR** → new features, backwards compatible (`v1.1.0`)
* **PATCH** → bug fixes only (`v1.0.1`)
* Pre-release → `v1.0.0-rc1`, `v1.0.0-beta.2`

### 5. Automating Releases

You can automate tagging + changelog + GitHub/GitLab release:

* Use **GitHub Actions** or **GitLab CI/CD** to:

  * Generate changelogs
  * Build artifacts
  * Publish Docker images
* Example: [semantic-release](https://github.com/semantic-release/semantic-release) tool can do this.




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

export PORT_CORE=8081 && export HOST_NAME=localhost && export PORT_APP=3031 && ./scripts/startup-local.sh mongo
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

