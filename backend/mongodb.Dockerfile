# Dockerfile for MongoDB

# Use the official MongoDB image as the base
FROM mongo:7.0.12

# Use ARG to define a build-time variable
ARG MONGODB_HOST
ARG MONGODB_PORT
ARG MONGODB_USER
ARG MONGODB_PWD

# Use that ARG to set an environment variable
ENV MONGODB_HOST=${MONGODB_HOST}
ENV MONGO_INITDB_ROOT_USERNAME=${MONGODB_USER}
ENV MONGO_INITDB_ROOT_PASSWORD=${MONGODB_PWD}

# Expose port given by input parameter
EXPOSE ${MONGODB_PORT}
