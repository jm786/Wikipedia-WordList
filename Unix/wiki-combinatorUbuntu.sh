#!/bin/sh

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
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
	echo "Python3.7 has been installed"
fi

if [ `which pip | egrep -c "pip"` -gt 0 ]
then
	echo "Pip3 is installed"
else
	echo "Installing Pip3"
	wget https://bootstrap.pypa.io/get-pip.py
	python3.7 get-pip.py
	rm get-pip.py
	echo "Pip3 has been installed"
fi

python3.7 -m pip install -qqq pip -U
python3.7 -m pip install -qqq tqdm wget

echo "Creating lists for all dumps in the folder"
master_path=$PWD
list_path=$master_path/wikilists

if [ -d $list_path ]
then
	rm -rf $list_path
	mkdir $list_path
else
        mkdir $list_path
fi
echo "Wikilists directory created successfully"

dump_path=$master_path/wikidumps

if [ -d $dump_path ]
then
	rm -rf $dump_path
	mkdir %dump_path
else
        mkdir $dump_path
fi
echo "Wikidumps directory created successfully"

cd $dump_path
python3.7 $master_path/namescraper.py
cd $list_path

for file in $dump_path/*
do
        if [ `echo $file | egrep '\.xml$'` ]
        then
		filename=`echo $file | egrep -o '[a-z][a-z]wiki[a-z]*-latest-pages-articles\.xml$'`
                sh $master_path/extractor.sh $file $list_path
	fi
done

echo "Merging lists together"
cd $list_path

result_path=$master_path/wiki-extraction-wordlist.txt
touch $result_path

bash -c "sort -u *-wordlist.txt >> $result_path"
cd ..

rm -rf $list_path
rm -rf $dump_path

echo "wiki-extraction-wordlist.txt has been created. It contains all the words from the wikimedia dumps."
