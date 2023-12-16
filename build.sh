#!/bin/bash

# Change to micropython folder

startpath=$(pwd)

# initialize idf
cd $startpath/build/esp-idf
source export.sh

# got to micropython build folder
cd $startpath/build/micropython/ports/esp32

#copy over modules
rm ./modules/*
cp $startpath/modules/* ./modules/

# run build
make USER_C_MODULES=$startpath/build/s3lcd/src/micropython.cmake FROZEN_MANIFEST="" FROZEN_MPY_DIR=$UPYDIR/modules BOARD=GENERIC_S3_SPIRAM_OCT

# copy result to firmware folder if build was successful

if [ $? -eq 0 ]; then
    echo "Build succeeded"
    timestamp=$(date +"%Y-%m-%d_%H:%M:%S")
    mkdir "$startpath/firmware/$timestamp"
    cp $startpath/build/micropython/ports/esp32/build-GENERIC_S3_SPIRAM_OCT/firmware.bin $startpath/firmware/$timestamp
else
    echo "Build failed"
fi
