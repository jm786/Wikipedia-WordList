#!/bin/sh
apt update -qqq

if [ `which python3.7 | egrep -c "python3.7"` -gt 0 ]
then
	echo "Python3.7 is installed"
else
	echo "Installing Python 3.7"
	apt install -qqq software-properties-common
	add-apt-repository ppa:deadsnakes/ppa > /dev/null 2>&1
	apt -qqq update
	apt install -qqq python3.7
	apt -qqq update
fi

if [ `which pip | egrep -c "pip"` -gt 0 ]
then
	echo "Pip is installed"
else
	echo "Installing pip"
	apt -qqq install python3-pip
	python3.7 -m pip -qqq install --upgrade pip
fi

apt install -qqq python3-regex python3-wget
python3.7 -m pip install -qqq tqdm filesplit

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
#python3.7 $master_path/namescraper.py
chdir ..

for file in $dump_path/*
do
        if [ `echo $file | egrep '\.xml$'` ]
        then
		filename=`echo $file | egrep -o '[a-z][a-z]wiki[a-z]*-latest-pages-articles\.xml$'`
                python3.7 extractor.py $filename $dump_path $processors
	fi
done

