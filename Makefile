.PHONY: build_standalone build_php build_webserver build_all run_compose

PHP_VERSION=7.2
REGISTRY_ENDPOINT=masselot-lydia

build_php:
	docker build -t ${REGISTRY_ENDPOINT}-php --build-arg PHP_VERSION=${PHP_VERSION} -f dockerfiles/Dockerfile.php-fpm .

build_webserver:
	docker build -t ${REGISTRY_ENDPOINT}-nginx -f dockerfiles/Dockerfile.web .

build_standalone:
	docker build -t ${REGISTRY_ENDPOINT}-standalone --build-arg PHP_VERSION=${PHP_VERSION} -f dockerfiles/Dockerfile .

build_all: build_php build_webserver build_standalone

run_compose:
	docker-compose -f deployment/compose/docker-compose.yml up -d
