#!/bin/bash

cd library_creation
./create_library.sh

cp library_files/Lib* ../PIPE_VGA
cp library_files/Lib* ../BIRD_VGA
cp library_files/Lib* ../BACKGROUND_VGA

cd ../PIPE_VGA
./create_pipe.sh

cd ../BIRD_VGA
./create_bird.sh

cd ../BACKGROUND_VGA
./create_background.sh
