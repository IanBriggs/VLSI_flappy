#!/bin/bash

set -e i

if [! -a BIRD_VGA.v]
then
    echo "You must first create BIRD_VGA.v"
    exit -1
fi

if [! -a Lib6710_Personal.v]
then
    echo "You must first copy Lib6710_Personal.v"
    exit -1
fi

if [! -a Lib6710_Personal.lib]
then
    echo "You must first copy Lib6710_Personal.lib]"
    exit -1
fi

if [! -a Lib6710_Personal.lef]
then
    echo "You must first copy Lib6710_Personal.lef"
    exit -1
fi

if [! -a Lib6710_Personal.db]
then
    echo "You must first copy Lib6710_Personal.v"
    exit -1
fi

cp BIRD_VGA.v WORK
cp Lib6710_Personal.* WORK

cd WORK
cp synopsys_dc.setup.tcl .synopsys_dc.setup

syn-dc -f bird-syn-script.tcl

cad-edi -no-gui -file top-bird.tcl

cp BIRD_VGA_struct.v ../cadence_files/
cp BIRD_VGA.def ../cadence_files/
