#
# Makefile to manage this project's development environment.
# This will be mostly clojure!
#

TAG=markmandel/wrapping-dev
NAME=clojure-project-shell

#current dir
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_path := $(dir $(mkfile_path))

# Builds the development docker file
build:
	docker build --tag=$(TAG) ./dev
	notify-send "$(TAG) build complete"

# Clean this docker image
clean:
	-docker rmi $(TAG)

# Clean this docker image and it's dependency
clean-deps: clean
	-docker rmi java:jdk

# Start a development shell
shell:
	mkdir -p ~/.m2
	docker run --rm \
		--name=$(NAME) \
		-P=true \
		-e HOST_GID=`id -g` \
		-e HOST_UID=`id -u` \
		-e HOST_USER=$(USER) \
		-v $(current_path)/dev/profiles.clj:/home/$(USER)/.lein/profiles.clj \
		-v $(current_path)/dev/zshrc:/home/$(USER)/.zshrc \
		-v $(current_path):/project \
		-it $(TAG) /root/startup.sh

# Attach a new terminal to the already running shell
shell-attach:
	docker exec -it -u=$(USER) $(NAME) /usr/bin/zsh

debug:
	echo 