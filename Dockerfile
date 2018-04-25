FROM ubuntu:latest

ARG steam_username
ARG steam_password

# Do NOT remove
ENV DEBIAN_FRONTEND noninteractive

MAINTAINER "Benato Denis" <benato.denis96@gmail.com>

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN dpkg --add-architecture i386; apt-get update;apt-get install -y lib32gcc1 libstdc++6 libstdc++6:i386 libtbb2:i386 libtbb2 wget net-tools binutils apt-utils

RUN cd /root \
	&& wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz \
	&& tar -zxvf steamcmd_linux.tar.gz \
	&& rm -f steamcmd_linux.tar.gz

RUN /root/steamcmd.sh +login anonymous +quit
RUN echo 233780 > steam_appid.txt
RUN /root/steamcmd.sh +login $steam_username $steam_password +force_install_dir /arma3 +app_update 233780 verify +quit

VOLUME /profiles
VOLUME /server

EXPOSE 2301/udp
EXPOSE 2302/udp
EXPOSE 2303/udp
EXPOSE 2304/udp
EXPOSE 2305/udp
EXPOSE 2306/udp

WORKDIR /arma3

STOPSIGNAL SIGINT
CMD ["/arma3/arma3server", "-par=params", "-profiles=/profiles"]
