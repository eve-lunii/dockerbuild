# Docker build

## Installation

Install Docker on your machine and give your user docker rights.
You will need the dockerx plugin to retrieve the output.

## Basic docker commands

Download a standard container

    docker image pull ubuntu:22.04

Run interactive

    docker container run -it ubuntu:22.04 /bin/bash

List and kill a container

    docker ps -a

    docker kill $PID

## Build configuration

Create a key pair for Github:

    ssh-keygen -q -t rsa -N '' -f repo-key

Add it to the repository "Deploy keys" - we only need to git clone, no write rights needed.

Copy the arm stm32 toolchain in the current folder, name it gcc-arm-stm.
For instance:

    cp -r /opt/st/stm32cubeide_1.11.2/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.10.3-2021.10.linux64_1.0.100.202210260954/tools/ arm-stm

## Run build

Go into the directory containing your Dockerfile (named: Dockerfile) and run:

    docker build -t prettyname ./ --output type=tar,dest=build.tar

Then run your new container:

    docker run prettyname

Untar the build

    tar xvf build.tar --one-top-level
