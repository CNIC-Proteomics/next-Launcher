@echo off
setlocal enabledelayedexpansion

:: Check if the .env file is provided as an input parameter
if "%1"=="" (
  echo.
  echo Usage: %0 ^<path_to_env_file^> [docker-compose-file]
  echo Examples:
  echo    .\bin\docker-compose.bat .env
  echo    .\bin\docker-compose.bat .env_cnic_dev docker-compose.cnic_dev.yml
  echo.
  exit /b 1
)
set "ENV_FILE=%1"

:: Set default value for the docker-compose file if not provided
if "%2"=="" (
  set "COMPOSE_FILE=docker-compose.yml"
) else (
  set "COMPOSE_FILE=%2"
)

:: Check if the provided .env file exists
if not exist "%ENV_FILE%" (
  echo The specified .env file does not exist: %ENV_FILE%
  echo.
  exit /b 1
)

:: Check if the provided docker-compose file exists
if not exist "%COMPOSE_FILE%" (
  echo The specified docker-compose file does not exist: %COMPOSE_FILE%
  echo.
  exit /b 1
)

:: Load environment variables from the specified .env file, ignoring comments
for /f "usebackq tokens=1,* delims==" %%A in ("%ENV_FILE%") do (
  if not "%%A"=="" (
    set "KEY=%%A"
    set "VALUE=%%B"
    setlocal enabledelayedexpansion
    set "!KEY!=!VALUE!"
    endlocal & set "!KEY!=!VALUE!"
  )
)

:: Check if NL_VERSION is defined
if "!NL_VERSION!"=="" (
  echo 'NL_VERSION' is required in the .env file.
  exit /b 1
)

:: Check if NL_PREVIOUS_VERSION is defined
if "!NL_PREVIOUS_VERSION!"=="" (
  echo 'NL_PREVIOUS_VERSION' is not defined. Using NL_VERSION '!NL_VERSION!' image from DockerHub...

  :: Build docker-compose
  echo docker-compose --env-file "!ENV_FILE!" -f "!COMPOSE_FILE!" up -d
  docker-compose --env-file "!ENV_FILE!" -f "!COMPOSE_FILE!" up -d

) else (
  echo NL_PREVIOUS_VERSION is defined: !NL_PREVIOUS_VERSION!

  :: Declare image names
  set "PREVIOUS_IMAGE=proteomicscnic/next-launcher-db:!NL_PREVIOUS_VERSION!"
  set "IMAGE_NAME=proteomicscnic/next-launcher-db:!NL_VERSION!"
  
  :: Capture the output of docker images. Check if the variable is set
  for /f "tokens=*" %%i in ('docker images --format "{{.Repository}}:{{.Tag}}" ^| findstr /C:"!PREVIOUS_IMAGE!"') do set "FOUND_IMAGE=%%i"
  if defined FOUND_IMAGE (
    :: Tagging the previous image with the new version
    echo Image !PREVIOUS_IMAGE! exists. Tagging it as !IMAGE_NAME!...
    docker tag !PREVIOUS_IMAGE! !IMAGE_NAME!
  ) else (
    echo Image !PREVIOUS_IMAGE! does not exist locally
  )
  :: Build docker-compose
  echo docker-compose --env-file "!ENV_FILE!" -f "!COMPOSE_FILE!" up -d
  docker-compose --env-file "!ENV_FILE!" -f "!COMPOSE_FILE!" up -d

)

echo Docker container setup complete.
