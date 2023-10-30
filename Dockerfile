# syntax=docker/dockerfile:1
# Tell the BuildKit image builder in Docker to use Dockerfile frontend for support of new features

FROM node:21.1.0-bullseye-slim AS development

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json to container
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

# Same as npm install
RUN npm ci && npm cache clean --force

# Copy the source code directories and .nginx/nginx.conf to main container's directory
COPY src /app/src
COPY public /app/public
COPY .nginx/nginx.conf /app/.nginx/nginx.conf

# Set environment variables inside the container
ENV CI=true
ENV PORT=3000

CMD [ "npm", "start" ]


FROM development AS build

RUN npm run build


FROM development as dev-envs

ENV PATH /app/node_modules/.bin:$PATH
ENV NODE_ENV=development

RUN apt-get update && apt-get install -y --no-install-recommends git=1:2.30.2-1+deb11u2

RUN useradd -s /bin/bash -m vscode && \
    groupadd docker && \
    usermod -aG docker vscode

# Install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /

RUN npm install && npm cache clean --force
RUN npm install -g nodemon@3.0.1

CMD [ "nodemon", "--inspect=0.0.0.0:9229"]


### Stage for unit tests
FROM development AS unit-test

## Update apk and add npm
RUN apt-get update; \
    apt-get install -y --no-install-recommends npm=7.5.2+ds-2;

## Copy the /app dir from builder stage in order to be able to do the unit tests
COPY --from=build /app /test-app


## Nginx unprivileged debian image
FROM nginxinc/nginx-unprivileged:1.25

## Switch to root user for setup
USER root

## Setup package(s)
RUN apt-get update; \
    apt-get install -y --no-install-recommends iputils-ping=3:20221126-1

# Copy config nginx
COPY --from=build /app/.nginx/nginx.conf /etc/nginx/nginx.conf

# Copy mime.types from nginx image
COPY --from=nginx:alpine /etc/nginx/mime.types /etc/nginx/mime.types

WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy static assets from builder stage
COPY --from=build /app/build .

## Expose port 8080
EXPOSE 8080

## Switch to non-root user
USER nginx

## Healthchecks
# TODO Later, when you move from the self-signed certificates delete "-k" flag
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -k -f https://localhost:8080 || exit 1
