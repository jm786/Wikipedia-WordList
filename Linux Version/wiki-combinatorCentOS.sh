#!/bin/sh

# WORK IN PROGRESS DO NOT USE
# echo WORK IN PROGRESS DO NOT USE

yum -y -q update

if [ `which python3.7 | egrep -c "python3.7"` -gt 0 ]
then
	echo "Python3.7 is installed"
else
	echo "Installing Python 3.7"
	yum -y -q install gcc openssl-devel bzip2-devel libffi-devel wget
	cd /usr/src && wget -q https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz
	tar xzf Python-3.7.3.tgz && cd Python-3.7.3 && ./configure --enable-optimizations >/dev/null
	make altinstall >/dev/null && rm /usr/src/Python-3.7.3.tgz
	yum -y -q update
fi

if [ `which pip | egrep -c "pip"` -gt 0 ]
then
	echo "Pip is installed"
	pip3 -qqq install --update pip
else
	echo "Installing pip"
	yum -y -q install epel-release && yum -y -q makecache && yum -y -q install python34-pip
	pip3 -qqq install --update pip
	yum -y -q update
fi

pip3 -qqq install tqdm filesplit wget

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
python3.7 $master_path/namescraper.py
chdir ..

for file in $dump_path/*
do
				if [ `echo $file | egrep '\.xml$'` ]
        then
								filename=`echo $file | egrep -o '[a-z][a-z]wiki[a-z]*-latest-pages-articles\.xml$'`
                sh extractor.sh $filename
				fi
done

echo "Merging lists together"
chdir $list_path
echo $PWD

result_path=$master_path/wiki-extraction-wordlist.txt
touch $result_path

sort -u ./*-wordlist.txt >> $result_path
chdir ..

rm -rf $list_path
rm -rf $dump_path
rm -rf $master_path/wikisplits

echo "wiki-extraction-wordlist.txt has been created. It contains all the words from the wikimedia dumps."
