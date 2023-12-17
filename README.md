# orthoverse-s3
Firmware and code for building an Orthoverse T-Display-S3 display device. Note that this repository also provides general information for anyone wanting to code in micropython for the Lilygo T-Display-S3 and then compile and flash functioning firmware to the device.

Almost all the information to do this was available on the Internet, but it was scattered all over the place, and a few key pieces were missing.

I aim to make my repositories as understandable as possible, so if you find yourself confused please open an issue explaining your problem and I'll try to resolve it.

## Installing and running on Ubuntu 22.04

Ensure you have the latest packages and everything is up to date:
```
apt-get -y update
apt-get -y upgrade
```

Install the required packages
```
apt-get -y install build-essential libffi-dev git pkg-config cmake virtualenv python3-pip python3-virtualenv python3-libusb1
```

Then run `./setup.sh` to clone and install all required repositories

Build firmware with `./build.sh`

## Setting up a docker firmware building image

Please note that I like my repositories to document the journey, rather than just the end result.

### Configure a container from scratch
One approach is to start a Ubuntu docker container, and run the setup.sh script to configure it correctly, although this takes quite some time if you want to run the container again and again. It is, however, a useful tutorial.

1. Install docker if you don't have it already. See [the docker install guide](https://docs.docker.com/engine/install/ubuntu/)

2. Run the following command from this repository's main folder to start an interactive bash terminal, with the current folder mapped to /orthoverse-s3:

`docker run -v "$(pwd)":/orthoverse-s3/ -it ubuntu:22.04 /bin/bash`

3. Change to the mapping of this repository:

`cd /orthvoerse-s3/`

4. Run the setup script, which should clone and build all the required tools for you:

`./setup.sh`

### Build an image for your build container using the Dockerfile

A better long-term solution is to build an image that is configured correctly to make board builds correctly.

`docker build -f Dockerfile -t s3lcd-build --compress .`

Once you have the build image, you can start it immediately using:

`docker run -it s3lcd-build`

To make a build, run `c./build.sh`

TODO: add instruction to map firmware folder and modules folder to local machine.

## Flashing firmware.bin

The instructions for flashing the `firmware.bin` file to your device are [here](https://medium.com/@kf106/a-deadfellaz-device-for-halloween-051fc5832ace)

