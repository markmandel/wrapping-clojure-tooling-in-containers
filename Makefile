#
# Makefile to manage this project's development environment.
# This will be mostly clojure!
#

TAG=markmandel/clojure-dev
NAME=wrapping-clojure-shell
WEB_PORT=8080

#Directory that this Makefile is in.
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_path := $(dir $(mkfile_path))

# Builds the development docker file
docker-build:
	docker build --tag=$(TAG) ./dev
	notify-send "$(TAG) build complete"

# Clean this docker image
docker-clean:
	-docker rmi $(TAG)

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

# mount the docker's jvm in the /tmp dir
shell-mount-jvm:
	mkdir -p /tmp/$(NAME)/jvm
	sshfs $(USER)@0.0.0.0:/usr/lib/jvm /tmp/$(NAME)/jvm -p $(call getPort,22) -o follow_symlinks

# open a port forwarded port from Docker in Chrome! (Defaults to 8080)
chrome:
	google-chrome http://localhost:$(call getPort,$(WEB_PORT))

# emacs
emacs:
	xpra start --ssh="ssh -p $(call getPort,22)" ssh:0.0.0.0:100 \
		--start-child=emacs --exit-with-children --encoding=png

# if your connection disconnects, reconnect to your xpra session.
emacs-attach:
	xpra attach --ssh="ssh -p $(call getPort,22)" ssh:0.0.0.0:100

# install dependencies, which is pretty much xpra
install-ubuntu-dependencies:
	codename=$(word 2, $(shell lsb_release --codename)) && \
	echo Installing xpra debs for release: $$codename && \
	wget -O /tmp/python-rencode.deb https://www.xpra.org/dists/$$codename/main/binary-amd64/python-rencode_1.0.3-1_amd64.deb && \
	wget -O /tmp/xpra.deb https://www.xpra.org/dists/trusty/main/binary-amd64/xpra_0.15.9-1_amd64.deb
	sudo dpkg -i /tmp/python-rencode.deb
	-sudo dpkg -i /tmp/xpra.deb
	sudo apt-get install -f -y

# Reset everything back to the original version (last git commit)
src-reset:
	git reset --hard
	git clean -fd

# Functions

# get the mapped docker host port
getPort = $(word 2,$(subst :, ,$(shell docker port $(NAME) $(1))))