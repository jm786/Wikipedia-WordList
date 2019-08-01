#!/bin/sh

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo yum -y -q update
python3path=`which python3.7`
pip3path=`which pip3`

echo "Verifying Python3.7 Installation"
if [ `echo $python3path | egrep -c "python3.7"` -gt 0 ]
then
	echo "Python3.7 is installed"
else
	echo "Installing Python 3.7"
	sudo yum -y -q install gcc openssl-devel bzip2-devel libffi-devel wget
	cd /usr/src && sudo wget -q https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz
	sudo tar xzf Python-3.7.3.tgz && cd Python-3.7.3 && ./configure --enable-optimizations >/dev/null
	make altinstall >/dev/null && sudo rm /usr/src/Python-3.7.3.tgz
	sudo yum -y -q update
	python3path=`which python3.7`
	echo "Python3.7 has been installed"
fi

echo "Verifying Pip3 Installation"
if [ `echo $pip3path | egrep -c "pip3"` -gt 0 ]
then
	echo "Pip3 is installed"
	sudo "$pip3path" install pip -U -qqq
else
	echo "Installing pip"
	sudo yum -y -q install epel-release && yum -y -q makecache && yum -y -q install python34-pip
	pip3path=`which pip3`
	sudo "$pip3path" install pip -U -qqq
	sudo yum -y -q update
	echo "Pip3 has been installed"
fi

sudo "$pip3path" install tqdm wget --user -qqq

echo "Creating lists for all dumps in the folder"
master_path=$PWD
list_path=$master_path/wikilists

if [ -d $list_path ]
then
        sudo rm -rf $list_path
	sudo mkdir $list_path
else
        sudo mkdir $list_path
fi
echo "Wikilists directory created successfully"

dump_path=$master_path/wikidumps

if [ -d $dump_path ]
then
	sudo rm -rf $dump_path
	sudo mkdir $dump_path
else
        sudo mkdir $dump_path
fi
echo "Wikidumps directory created successfully"

cd $dump_path
# sudo "$python3path" $master_path/namescraper.py
cd $list_path

for file in $dump_path/*
do
	if [ `echo $file | egrep '\.xml$'` ]
        then
		filename=`echo $file | egrep -o '[a-z][a-z]wiki[a-z]*-latest-pages-articles\.xml$'`
                sudo sh $master_path/extractor.sh $file $list_path 
	fi
done

echo "Merging lists together"
cd $list_path

result_path=$master_path/wiki-extraction-wordlist.txt
sudo touch $result_path

sudo bash -c "sort -u *-wordlist.txt >> $result_path"
cd ..

sudo rm -rf $list_path
sudo rm -rf $dump_path

echo "wiki-extraction-wordlist.txt has been created. It contains all the words from the wikimedia dumps."
