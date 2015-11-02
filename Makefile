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
docker-build:
	docker build --tag=$(TAG) ./dev
	notify-send "$(TAG) build complete"

# Clean this docker image
docker-clean:
	-docker rmi $(TAG)

# Clean this docker image and it's dependency
docker-clean-deps: clean
	-docker rmi java:jdk

# delete the generated code, and get things at a base place
src-clean:
	-rm -r $(current_path)/src/*
	-rm -r $(current_path)/test
	-rm -r $(current_path)/resources
	-rm $(current_path)/project.clj
	-rm $(current_path)/README.md
	cp $(current_path)/orig/.gitignore $(current_path)/.gitignore
	cp $(current_path)/orig/README-parent.md $(current_path)/README.md

# Start a development shell
shell:
	mkdir -p ~/.m2
	docker run --rm \
		--name=$(NAME) \
		-P=true \
		-e HOST_GID=`id -g` \
		-e HOST_UID=`id -u` \
		-e HOST_USER=$(USER) \
		-v ~/.m2:/home/$(USER)/.m2 \
		-v $(current_path)/dev/profiles.clj:/home/$(USER)/.lein/profiles.clj \
		-v $(current_path)/dev/zshrc:/home/$(USER)/.zshrc \
		-v $(current_path):/project \
		-it $(TAG) /root/startup.sh

# Attach a new terminal to the already running shell
shell-attach:
	docker exec -it -u=$(USER) $(NAME) /usr/bin/zsh

# install dependencies, which is pretty much xpra
install-ubuntu-dependencies:
	codename=$(word 2, $(shell lsb_release --codename)) && \
	echo Installing xpra debs for release: $$codename && \
	wget -O /tmp/python-rencode.deb https://www.xpra.org/dists/$$codename/main/binary-amd64/python-rencode_1.0.3-1_amd64.deb && \
	wget -O /tmp/xpra.deb https://www.xpra.org/dists/$$codename/main/binary-amd64/xpra_0.15.7-1_amd64.deb
	sudo dpkg -i /tmp/python-rencode.deb
	sudo dpkg -i /tmp/xpra.deb
	sudo apt-get install -f

