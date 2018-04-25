FROM ubuntu:latest

ARG steam_username
ARG steam_password

# Do NOT remove
ENV DEBIAN_FRONTEND noninteractive

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN dpkg --add-architecture i386; apt-get update;apt-get install -y lib32gcc1 libstdc++6 libstdc++6:i386 libtbb2:i386 libtbb2 wget net-tools binutils apt-utils

RUN mkdir /home/steam
RUN adduser --home /home/steam steam
RUN chown steam -R /home/steam
RUN mkdir /arma3
RUN chown steam -R /arma3
RUN mkdir /profiles
RUN chown steam -R /profiles

# Login to the steam user
USER steam
RUN cd /home/steam
WORKDIR /home/steam

# Download and unpack SteamCMD
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz \
	&& tar -zxvf steamcmd_linux.tar.gz \
	&& rm -f steamcmd_linux.tar.gz

# Login into Steam and download the Arma3 server
RUN ./steamcmd.sh +login $steam_username $steam_password +force_install_dir /arma3 +app_update 233780 verify +quit

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
