# Arma3-Docker
Arma III containerized with docker.

## Building
The container __must__ be built on the target machine, because logging into steamcmd is required,
and leaving valid username and password violates the steam EULA.

Before building the container you have to:
1. Create a new Steam account (you do __not__ need to buy the game)
2. Disable Steam Guard on that account

When you're done:

```bash
git clone <repository url>
cd Arma3-Docker
docker build  --build-arg steam_username=<steam username> --build-arg steam_password=<steam password> -t neroreflex/arma3 .
```

Now you just have to wait for SteamCMD to download Arma3 server files (those are a few GB).


## Running
Running the server is straightforward, thank to the included *run.sh* script:

```bash
# Create the container
./run.sh
```

Enjoy your Arma3 server running inside a secure docker container!