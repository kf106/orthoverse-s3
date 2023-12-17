FROM ubuntu:22.04
LABEL authors="kf106"

USER root

# ensure image has latest packages and is up to date
RUN apt-get -y update
RUN apt-get -y upgrade

# install required packages
RUN apt-get -y install build-essential libffi-dev git pkg-config cmake virtualenv python3-pip python3-virtualenv python3-libusb1 apt-utils

WORKDIR tmp
RUN git clone https://github.com/kf106/orthoverse-s3.git
RUN ls
WORKDIR /tmp/orthoverse-s3
RUN ./setup.sh

ENTRYPOINT ["/bin/bash"]
