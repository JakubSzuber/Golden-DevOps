# syntax=docker/dockerfile:1.4

# 1. For build React app
FROM node:20.2.0-bullseye-slim AS development

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json to container
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

# Same as npm install
RUN npm ci && npm cache clean --force

COPY . /app

ENV CI=true
ENV PORT=3000

CMD [ "npm", "start" ]


FROM development AS build

RUN npm run build


FROM development as dev-envs

ENV PATH /app/node_modules/.bin:$PATH
ENV NODE_ENV=development

RUN apt-get update && apt-get install -y --no-install-recommends git

RUN useradd -s /bin/bash -m vscode && \
groupadd docker && \
usermod -aG docker vscode

# Install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /

RUN npm install && npm cache clean --force
RUN npm install -g nodemon

CMD [ "nodemon", "--inspect=0.0.0.0:9229"]


## Nginx lightweight alpine image
FROM nginx:1.24-alpine-slim

## Update apk and add curl
RUN apk update; \
    apk add --no-cache curl; \
    apk add nodejs npm;

# Copy config nginx
COPY --from=build /app/.nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy static assets from builder stage
COPY --from=build /app/build .

# Copy the /app dir from builder stage in order to be able to do the unit tests
COPY --from=build /app /test-app

## Add permissions
RUN chown -R nginx:nginx /usr/share/nginx && \
        chown -R nginx:nginx /var/cache/nginx && \
        chown -R nginx:nginx /var/log/nginx && \
        chown -R nginx:nginx /etc/nginx/conf.d
RUN touch /var/run/nginx.pid && \
        chown -R nginx:nginx /var/run/nginx.pid

## Switch to non-root user
USER nginx

## Healthchecks
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1
