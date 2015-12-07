#!/bin/bash

set -e i

if [ ! -f BACKGROUND_VGA.v ]
then
    echo "You must first create BACKGROUND_VGA.v"
    exit -1
fi

if [ ! -f Lib6710_Personal.v ]
then
    echo "You must first copy Lib6710_Personal.v"
    exit -1
fi

if [ ! -f Lib6710_Personal.lib ]
then
    echo "You must first copy Lib6710_Personal.lib]"
    exit -1
fi

if [ ! -f Lib6710_Personal.lef ]
then
    echo "You must first copy Lib6710_Personal.lef"
    exit -1
fi

if [ ! -f Lib6710_Personal.db ]
then
    echo "You must first copy Lib6710_Personal.v"
    exit -1
fi

cp BACKGROUND_VGA.v WORK
cp Lib6710_Personal.* WORK

cd WORK
cp synopsys_dc.setup.tcl .synopsys_dc.setup

syn-dc -f background-syn-script.tcl

cad-edi -no_gui -file top-background.tcl

cp BACKGROUND_VGA_struct.v ../cadence_files/
cp BACKGROUND_VGA.def ../cadence_files/
