#!/bin/sh

if [ $# -eq 1 ]
then
<<<<<<< HEAD
	processors=$1
else
	processors=10
=======
        processors=$1
else
        processors=10
>>>>>>> 289b7d2efede768c2c9a686092ac8d6233350dd3
fi

echo "Creating lists for all dumps in the folder"
master_path=$PWD
list_path=$master_path/wikilists

if [ -d $list_path ]
then
<<<<<<< HEAD
	echo "Creation of the Wikilists directory failed"
else
	mkdir $list_path
	echo "Wikilists directory created successfully"
=======
        echo "Creation of the Wikilists directory failed"
else
        mkdir $list_path
        echo "Wikilists directory created successfully"
>>>>>>> 289b7d2efede768c2c9a686092ac8d6233350dd3
fi

dump_path=$master_path/wikidumps

if [ -d $dump_path ]
then
<<<<<<< HEAD
	echo "Creation of the Wikidumps directory failed"
else
	mkdir $dump_path
	echo "Wikiidumps directory created successfully"

=======
        echo "Creation of the Wikidumps directory failed"
else
        mkdir $dump_path
        echo "Wikiidumps directory created successfully"
>>>>>>> 289b7d2efede768c2c9a686092ac8d6233350dd3
