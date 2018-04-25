#!/bin/sh

# Create the directory structure
mkdir keys
mkdir mods
mkdir mpmissions
mkdir server
mkdir params
mkdir profiles

# Run the container in daemon mode
docker run -d \
	-v $PWD/keys:/arma3/keys \
	-v $PWD/mods:/arma3/mods \
	-v $PWD/mpmissions:/arma3/mpmissions \
	-v $PWD/server:/server \
	-v $PWD/params:/arma3/params \
	-v $PWD/profiles:/profiles \
	-p 2302-2306:2302-2306/udp \
	--name arma3 \
	neroreflex/arma3

