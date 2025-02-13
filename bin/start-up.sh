#!/bin/bash

# Check if the .env file is provided as an input parameter
if [ -z "$1" ]; then
  echo
  echo "Usage: $0 <path_to_env_file> [docker-compose-file]"
  echo "Examples:"
  echo "  ./bin/docker-compose.sh .env"
  echo "  ./bin/docker-compose.sh .env_cnic_dev docker-compose.cnic_dev.yml"
  echo
  exit 1
fi

ENV_FILE="$1"

# Set default value for the docker-compose file if not provided
if [ -z "$2" ]; then
  COMPOSE_FILE="docker-compose.yml"
else
  COMPOSE_FILE="$2"
fi

# Check if the provided .env file exists
if [ ! -f "$ENV_FILE" ]; then
  echo "The specified .env file does not exist: $ENV_FILE"
  echo
  exit 1
fi

# Check if the provided docker-compose file exists
if [ ! -f "$COMPOSE_FILE" ]; then
  echo "The specified docker-compose file does not exist: $COMPOSE_FILE"
  echo
  exit 1
fi

# Load environment variables from the specified .env file, ignoring comments
export $(grep -v '^#' "$ENV_FILE" | xargs)

# Check if NL_VERSION is defined
if [ -z "$NL_VERSION" ]; then
  echo "'NL_VERSION' is required in the .env file."
  exit 1
fi

# Check if NL_PREVIOUS_VERSION is defined
if [ -z "$NL_PREVIOUS_VERSION" ]; then
  echo "'NL_PREVIOUS_VERSION' is not defined. Using NL_VERSION '$NL_VERSION' image from DockerHub..."
  
  # Build docker-compose
  echo "docker-compose --env-file $ENV_FILE -f $COMPOSE_FILE up -d"
  docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" up -d

else
  echo "NL_PREVIOUS_VERSION is defined: $NL_PREVIOUS_VERSION"

  # Declare image names
  PREVIOUS_IMAGE="proteomicscnic/next-launcher-db:$NL_PREVIOUS_VERSION"
  IMAGE_NAME="proteomicscnic/next-launcher-db:$NL_VERSION"
  
  # Check if the previous image exists locally. Check if the variable is set
  FOUND_IMAGE=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -F "$PREVIOUS_IMAGE")
  if [ -n "$FOUND_IMAGE" ]; then
    # Tagging the previous image with the new version
    echo "Image $PREVIOUS_IMAGE exists. Tagging it as $IMAGE_NAME..."
    docker tag "$PREVIOUS_IMAGE" "$IMAGE_NAME"
  else
    echo "Image $PREVIOUS_IMAGE does not exist locally."
  fi
  
  # Build docker-compose
  echo "docker-compose --env-file $ENV_FILE -f $COMPOSE_FILE up -d"
  docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" up -d
fi

echo "Docker container setup complete."
