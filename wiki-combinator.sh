#!/bin/sh
apt update

string=`which python3.7`
if [ !$string ]
then
	apt install software-properties-common
	add-apt-repository ppa:deadsnakes/ppa
	apt update
	apt install python3.7
	alias python3=python3.7
	apt update
fi

string=`which pip3`
if [ !$string ]
then
	apt install python3-pip
	pip3 install --upgrade pip
fi

apt install -qqq python-regex
pip3 install -qqq tqdm wget filesplit

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
