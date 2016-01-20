Example of Wrapping Clojure Development Tooling in a Containers
===============================================================

Code demo for my talk "Wrapping Clojure Development Tooling in a Containers".

Provides [Make](https://www.gnu.org/software/make/) targets for building and running the Clojure developer shell within the accompanying Docker container. 

## Presentation

[Blog post and see the recording of the presentation from Clojure/conj 2015.](http://www.compoundtheory.com/recording-wrapping-clojure-tooling-in-containers-part-2/)

## Make Variables

### TAG
The tag to give the docker container. You may want to change this if you want to
use this template for your own project

### NAME
The name of the container when it is running.

### WEB_PORT
The port your web application runs on inside the docker container.

## Make Targets

### docker-build
Builds the Clojure development Docker container for this project, installing on the required dependencies.
 
### docker-clean
Deletes the docker image entirely for this project. Useful if you want to rebuild from scratch.

### shell
Starts a development shell, with Java 8, and [Leiningen](http://leiningen.org/), oh-my-zsh and the lein plugin already installed.

This will likely only work on Linux in it's current form - but could be edited to work on OSX (PRs welcome).

### shell-attach
Attach a new terminal to an already running development shell

### shell-mount-jvm
Mount the development shell to the local /tmp directory via [sshfs](http://fuse.sourceforge.net/sshfs.html)

### chrome
Opens up chrome to the local port that is forwarded for port 8080 on the host.

### emacs
Uses [Xpra](https://www.xpra.org/) to open up emacs as a gui on the host.

### emacs-attach
If you get disconnected from [Xpra](https://www.xpra.org/), this will reattach you to the session

### install-ubuntu-dependencies
Installs Xpra (version 0.15.7), assuming you are running Ubuntu.

### src-reset
Reset everything back to the original version (last git commit)

## Licence

Apache 2.0

This is not an official Google Product.