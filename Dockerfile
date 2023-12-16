FROM ubuntu:22.04
LABEL authors="kf106"

USER root

# ensure image has latest packages and is up to date
RUN apt-get -y update
RUN apt-get -y upgrade

# install required packages
RUN apt-get -y install build-essential libffi-dev git pkg-config cmake virtualenv python3-pip python3-virtualenv python3-libusb1 apt-utils

# clone repositories in build folder
WORKDIR ./build
RUN git clone https://github.com/micropython/micropython.git
RUN git clone https://github.com/russhughes/s3lcd.git
RUN git clone --recursive https://github.com/espressif/esp-idf.git

# build correct version of esp-idf, the build environment
WORKDIR ./build/esp-idf
RUN git checkout v4.4.4
RUN git submodule update --init --recursive

# and install it
RUN ./install.sh

# build correct version of micropython
WORKDIR ./build/micropython/
RUN git checkout v1.20.0
RUN git submodule update --init
WORKDIR  ./build/micropython/mpy-cross/
RUN make
WORKDIR  ./build/micropython/ports/esp32

# update the board definition for the T-Display-3 which has a 16MB octal SPIRAM 
RUN sed -i 's/8MB=y/8MB=/' ./boards/GENERIC_S3_SPIRAM_OCT/sdkconfig.board
RUN sed -i 's/16MB=/16MB=y/' ./boards/GENERIC_S3_SPIRAM_OCT/sdkconfig.board
RUN sed -i 's/8MiB/16MiB/' ./boards/GENERIC_S3_SPIRAM_OCT/sdkconfig.board

ADD . /orthoverse-s3/

WORKDIR /orthoverse-s3

# edit bashrc to ensure export.sh is always run for esp-idf
RUN echo 'source /tmp/esp-idf/export.sh' >> /root/.bashrc

ENTRYPOINT ["/bin/bash"]
