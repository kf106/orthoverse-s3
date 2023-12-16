#!/bin/bash

# clone repositories in build folder
cd ./build
git clone https://github.com/micropython/micropython.git
git clone https://github.com/russhughes/s3lcd.git
git clone --recursive https://github.com/espressif/esp-idf.git

# build correct version of esp-idf, the build environment
cd esp-idf
git checkout v4.4.4
git submodule update --init --recursive

# and install it
./install.sh

# finally ensure that the required environment is exported
source export.sh

# checkout last working s3lcd state
cd ..
cd s3lcd/
git checkout 1946749dc68789240480834083f3d779c1415f37

# build correct version of micropython
cd ..
cd micropython/
git checkout v1.20.0
git submodule update --init
cd mpy-cross/
make
cd ..
cd ports/esp32

# update the board definition for the T-Display-3 which has a 16MB octal SPIRAM 
sed -i 's/8MB=y/8MB=/' ./boards/GENERIC_S3_SPIRAM_OCT/sdkconfig.board
sed -i 's/16MB=/16MB=y/' ./boards/GENERIC_S3_SPIRAM_OCT/sdkconfig.board
# sed -i 's/8MiB/16MiB/' ./boards/GENERIC_S3_SPIRAM_OCT/sdkconfig.board

# build.sh should now build the firmware
