# Install Docker Desktop on Windows

Reference: https://docs.docker.com/desktop/install/windows-install/


# Build the image of Nextflow core


Build the Docker image
------------------------------
Now that you have your Dockerfile, you can build your image. The docker build command does the heavy-lifting of creating a docker image from a Dockerfile.

Open Windows Prompt:
```
cd S:\U_Proteomica\UNIDAD\Softwares\jmrodriguezc\next-Launcher-core\frontend\build

docker build --no-cache -t proteomicscnic/next-launcher-app:1.0.0 -f frontend.Dockerfile .

```

Run the nextflow contaniner
------------------------------
```
docker run --name next-launcher-app -it -v workspace:/workspace -p 3001:3000 proteomicscnic/next-launcher-app:1.0.0
```
