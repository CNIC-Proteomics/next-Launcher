# Dockerfile for MongoDB

# Use the official MongoDB image as the base
FROM mongo:7.0.12

# Use ARG to define a build-time variable with a default value
ARG MONGODB_HOST=next-launcher-db
ARG MONGODB_PORT=27017
ARG MONGODB_USER=root
ARG MONGODB_PWD=

# Use that ARG to set an environment variable
ENV MONGODB_HOST=${MONGODB_HOST}
ENV MONGODB_PORT=${MONGODB_PORT}
ENV MONGO_INITDB_ROOT_USERNAME=${MONGODB_USER}
ENV MONGO_INITDB_ROOT_PASSWORD=${MONGODB_PWD}

# Expose port given by input parameter
EXPOSE ${MONGODB_PORT}

# Default command to run MongoDB
CMD ["mongod"]
# mongod \
#     --fork \
#     --dbpath /data/db \
#     --logpath /var/log/mongodb/mongod.log \
#     --bind_ip 0.0.0.0
