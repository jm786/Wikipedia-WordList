#!/bin/sh
apt update -qqq

string=`which python3.7`
if [ `cat $string | egrep -c "python3.7"` -gt 0 ]
then
	echo "Python3.7 is installed"
else
	echo "Installing Python 3.7"
	apt install -qqq software-properties-common
	add-apt-repository ppa:deadsnakes/ppa > /dev/null 2>&1
	apt -qqq update
	apt install -qqq python3.7
	alias python=python3.7
	apt -qqq update
fi

string=`which pip3`
if [ `cat $string | egrep -c "pip3"` -gt 0 ]
then
	echo "Pip3 is installed"
else
	echo "Installing pip3"
	apt -qqq install python3-pip
	pip3 -qqq install --upgrade pip
fi

apt install -qqq python-regex
pip3 install -qqq --user tqdm wget filesplit

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
fi

chdir $dump_path
python $master_path/namescraper.py

