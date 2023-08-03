# syntax=docker/dockerfile:1
FROM ubuntu:22.04 AS build-stage

# Install tools required for project
RUN apt update
RUN apt install -y git
RUN apt install -y gcc-arm-none-eabi
RUN apt install -y make cmake

# Install keys
ADD repo-key /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

# Create known_hosts
RUN touch /root/.ssh/known_hosts
# Add github to known hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# Clone the conf files into the docker container
WORKDIR /home
RUN git clone --branch develop git@github.com:lunii/firmware-fah-wifi.git

# Set environment variables for toolchain
ENV TOOLCHAIN_PREFIX=/usr/bin/arm-none-eabi-
ENV CC=$TOOLCHAIN_PREFIX"gcc"
ENV CXX=$TOOLCHAIN_PREFIX"g++"
ENV ENV_OBJCOPY=$TOOLCHAIN_PREFIX"objcopy"
ENV ENV_OBJDUMP=$TOOLCHAIN_PREFIX"objdump"
ENV SIZE_UTIL=$TOOLCHAIN_PREFIX"size"

# Build
WORKDIR /home/firmware-fah-wifi/source/lunii_firmware
RUN bash build.sh

# Export the build folder to an empty container to retrieve as output
FROM scratch as export-stage
COPY --from=build-stage /home/firmware-fah-wifi/source/lunii_firmware/build /
