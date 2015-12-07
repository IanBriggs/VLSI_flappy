#!/bin/bash

set -e i

if [ ! -f foo.scs ]
then
    echo "You must first netlist ss_test and put the netlist into foo.scs"
    exit -1
fi

if [ ! -f abstract.lef ]
then
    echo "You must first abstract your library and export it to abstract.lef"
    exit -1

fi
if [ ! -f footprints.def ]
then
    echo "You must first create footprints.def"
    exit -1
fi

sed '1,/END PROPERTYDEFINITIONS/d' abstract.lef > WORK/temp
cat TechHeader.lef WORK/temp > library_files/Lib6710_Personal.lef


cp foo.scs WORK
cp footprints.def WORK
cd WORK

sp2elc foo.scs dut.scs

cad-elc -S step1
cad-elc -S step2
cad-elc -S step3

cp foo.v ../library_files/Lib6710_Personal.v


cad-alf2lib foo

cp foo.lib Lib6710_Personal.lib
sed -ie 's/(foo)/(Lib6710_Personal)/g' Lib6710_Personal.lib
cp Lib6710_Personal.lib ../library_files

syn-dc -f convert_lib.tcl
cp  Lib6710_Personal.db ../library_files
