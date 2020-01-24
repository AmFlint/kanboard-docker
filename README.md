# Kanboard Containerization From Scratch

In this repository:
- Dockerfiles and necessary configuration files for all services running in a kanboard application
- Docker-compose files to build and run the application

With this repository, there are multiple ways to run Kanboard:
- **Standalone**: every services are packaged in a single Dockerfile, managed by supervisord process manager [see this Docker file](./dockerfiles/Dockerfile.standalone)
- **Separately**: each service runs in a different container, which may be run and scaled independently:
  - [Web server with nginx](./dockerfiles/Dockerfile.webserver)
  - [PHP-FPM](./dockerfiles/Dockerfile.php-fpm)

**Services running in a Kanboard application** (packaged and configured in this repository) :
- Web Server (I chose to use nginx)
- php-fpm

## Requirements

- install docker to build and run the application
- install docker-compose to run the example compose manifest (and test the application) 
- (Optional) Install Make to run build/run commands provided in this repository

## Installation

To build the different images:
- `make build_webserver` to build the nginx web server service for kanboard
- `make build_php` to build PHP-FPM service for kanboard (use argument `PHP_VERSION` to install a specific version of PHP, defaults to `7.2`)
- `make build_standalone` to build the standalone application (all-in-one container) (use argument `PHP_VERSION` to install a specific version of PHP, defaults to `7.2`)
- `make build_all` to build every docker image mentioned above

## Configuration

### Standalone App

To run the standalone docker container, you might provide some configuration either by mounting your kanboard's config.php inside /usr/share/kanboard/config.php

*Note that if you are using sqlite as a database driver, you might want to use a volume to persist your data locally, to restore your database's state between each execution*. 

### Separate App

This method implies that you deploy multiple containers (one for the webserver and one for PHP-FPM), so you have to provide different configuration variables for container communication:
- FASTCGI_HOST: ip address/domain name of your running PHP-FPM service
- FASTCGI_PORT: on which port is your PHP-FPM process running

*For Kanboard configuration, please refer to the Standalone configuration above* (inject this configuration and variables inside your PHP-FPM container). 

## Run the sample application

To run the sample application based on this repository's docker images, you may use the [sample docker-compose manifest](./deployment/compose/docker-compose.yml).
You may use the provided make command:
```bash
make run_compose
```

**Make sure to run make build_all before running the stack**.

This sample runs two different stacks:
- `Standalone application`:
  - Standalone Kanboard docker image (built in this repository) (configured via a config.php volume)
  - PostreSQL database
- `Split services`:
  - Kanboard webserver (nginx) built in this repository
  - Kanboard php-fpm built in this repository
  - MySQL Database