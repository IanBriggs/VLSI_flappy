#!/bin/bash

set -e i

if [ ! -f PIPE_VGA.v ]
then
    echo "You must first create PIPE_VGA.v"
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

cp PIPE_VGA.v WORK
cp Lib6710_Personal.* WORK

cd WORK
cp synopsys_dc.setup.tcl .synopsys_dc.setup

syn-dc -f pipe-syn-script.tcl

cad-edi -no_gui -file top-pipe.tcl

cp PIPE_VGA_struct.v ../cadence_files/
cp PIPE_VGA.def ../cadence_files/
