#!/bin/sh

if [ $# -eq 1 ]
then
        processors=$1
else
        processors=10
fi

echo "Creating lists for all dumps in the folder"
master_path=$PWD
list_path=$master_path/wikilists

if [ -d $list_path ]
then
        echo "Creation of the Wikilists directory failed"
else
        mkdir $list_path
        echo "Wikilists directory created successfully"
fi

dump_path=$master_path/wikidumps

if [ -d $dump_path ]
then
        echo "Creation of the Wikidumps directory failed"
else
        mkdir $dump_path
        echo "Wikiidumps directory created successfully"
