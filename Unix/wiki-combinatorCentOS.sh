#!/bin/sh

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo yum -y -q update
python3path=`which python3.7`
pippath=`which pip`

echo "Verifying Python3.7 Installation"
if [ `echo $python3path | egrep -c "python3.7"` -gt 0 ]
then
	echo "Python3.7 is installed"
else
	echo "Installing Python 3.7"
	sudo yum -y -q groupinstall "Development Tools" && sudo yum -y -q install wget
	cd /usr/src && sudo wget -q https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz
	sudo tar xzf Python-3.7.4.tgz && cd Python-3.7.4 && sudo ./configure --enable-optimizations >/dev/null
	sudo make altinstall >/dev/null && sudo rm /usr/src/Python-3.7.4.tgz
	sudo yum -y -q update
	python3path=`which python3.7`
	echo "Python3.7 has been installed"
fi

echo "Verifying Pip Installation"
if [ `echo $pippath | egrep -c "pip"` -gt 0 ]
then
	echo "Pip is installed"
	sudo "$python3path" -m pip install --upgrade pip -qqq 
else
	echo "Installing Pip"
	sudo yum -y -q install epel-release && yum -y -q makecache && yum -y -q install python-pip
	pippath=`which pip`
	sudo "$python3path" install --upgrade pip -qqq
	sudo yum -y -q update
	echo "Pip has been installed"
fi

sudo "$python3path" -m pip install tqdm wget --user -qqq

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
sudo "$python3path" $master_path/namescraper.py
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
