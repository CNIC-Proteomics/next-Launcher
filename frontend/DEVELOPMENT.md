# Install Docker Desktop on Windows
------------------------------

Reference: https://docs.docker.com/desktop/install/windows-install/


# Build the image of Nextflow core
------------------------------
Now that you have your Dockerfile, you can build your image. The docker build command does the heavy-lifting of creating a docker image from a Dockerfile.

Open Windows Prompt:
```
cd S:\U_Proteomica\UNIDAD\DatosCrudos\jmrodriguezc\projects\next-Launcher\frontend\build

docker build -t frontend -f frontend.Dockerfile .
```
