.PHONY: build_kanboard_standalone build_php build_webserver

build_php:
	docker build -t masselot-lydia-php -f dockerfiles/Dockerfile.php-fpm .

build_webserver:
	docker build -t masselot-lydia-nginx -f dockerfiles/Dockerfile.web .

build_kanboard_standalone:
	docker build -t masselot-lydia-webserver -f dockerfiles/Dockerfile .

build_all: build_php build_webserver

run_compose:
	docker-compose -f deployment/compose/docker-compose.yml up -d
