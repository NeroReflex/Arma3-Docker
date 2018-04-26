FROM ubuntu:latest

# Expose networking ports in order to let players connect to the current host
EXPOSE 2301/udp
EXPOSE 2302/udp
EXPOSE 2303/udp
EXPOSE 2304/udp
EXPOSE 2305/udp
EXPOSE 2306/udp

# Build arguments are steam username and password
ARG steam_username
ARG steam_password

# Do NOT remove
ENV DEBIAN_FRONTEND noninteractive

# Install required software
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN dpkg --add-architecture i386; apt-get update;apt-get install -y lib32gcc1 libstdc++6 libstdc++6:i386 libtbb2:i386 libtbb2 wget net-tools binutils apt-utils nano

# Create another user account to be used for tunning the server
RUN adduser --disabled-login --home /home/steam --quiet steam
RUN chown steam -R /home/steam
RUN mkdir /arma3
RUN chown steam -R /arma3
RUN mkdir /profiles
RUN chown steam -R /profiles

# Login to the new user account
USER steam
RUN cd /home/steam
WORKDIR /home/steam

# Download and unpack SteamCMD
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
	&& tar -zxf steamcmd_linux.tar.gz \
	&& rm -f steamcmd_linux.tar.gz

# Login into Steam and download the Arma3 server
RUN ./steamcmd.sh +login $steam_username $steam_password +force_install_dir /arma3 +app_update 233780 verify +quit

#VOLUME /profiles
#VOLUME /server

# Create links for case-sensitive problems
RUN ln -s /arma3/mpmissions /arma3/MPMissions
RUN ln -s /arma3/keys /arma3/Keys

# Create the logfile
RUN touch /arma3/server_console.log

WORKDIR /arma3

COPY server.cfg /arma3/server.cfg

# Run the server
STOPSIGNAL SIGINT
CMD ["/arma3/arma3server", "-par=params", "-profiles=/profiles", "-port=2302", "-config=/arma3/server.cfg"]
