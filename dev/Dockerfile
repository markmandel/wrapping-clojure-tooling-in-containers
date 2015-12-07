#
# Shell for Clojure development, with Leiningen
#

FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y zsh openssh-server git gdebi wget x11-apps emacs software-properties-common \
    tree xvfb xserver-xorg-core

# install java
RUN apt-add-repository ppa:webupd8team/java && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer

#sshd setup - https://docs.docker.com/examples/running_ssh_service/
RUN mkdir /var/run/sshd
RUN echo 'root:pw' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22

#xpra
RUN wget -O python-rencode.deb https://www.xpra.org/dists/trusty/main/binary-amd64/python-rencode_1.0.3-1_amd64.deb && \
    gdebi -n python-rencode.deb && \
    rm python-rencode.deb

RUN wget -O xpra.deb https://www.xpra.org/dists/trusty/main/binary-amd64/xpra_0.15.9-1_amd64.deb && \
    gdebi -n xpra.deb && \
    rm xpra.deb

#oh-my-zsh, because how do we live without it?
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git

#lein installation
ENV LEIN_ROOT=1
RUN cd /usr/local/bin/ && wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && chmod +x ./lein

RUN lein

ADD startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

RUN mkdir /project
WORKDIR /project

#port for my web app
ENV PORT=8080
EXPOSE 8080