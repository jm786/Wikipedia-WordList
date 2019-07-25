#!/bin/sh
clear
echo "###########################################################"
echo "# Wikipedia Wordlists Extractor 1.0"
echo "# usage: sh extractor.sh wiki-file.xml"
echo "#"
echo "# https://github.com/ewwink/wikipedia-wordlists-extractor"
echo "# by ewwink"
# Rendered functioning by Jean-Baptiste Mollet
echo "###########################################################"
echo ""

XMLFILE=$1
FILERESULT=$XMLFILE"-wordlists.txt"

if [ $# -eq 0 ] ; then
    echo 'no File Specified, read the usage above'
        echo "exit"
    exit 0
fi

echo "Splitting File "$XMLFILE" ...."
if [ -d wikitmp ]; then
        rm -rf wikitmp
fi

if [ ! -d wikitmp ]; then
        mkdir wikitmp
fi

split -l 300000 $XMLFILE wikitmp/wiki_
echo ""

echo "Removing non AlphaNumeric Character"
cd wikitmp
perl -pi -e 's/[\W_$\[\]]+/\n/g' wiki_*
echo ""

echo "Removing wiki hash"
perl -pi -e 's/.{31}//g' wiki_*
echo ""

echo "Removing 1-3 Character length"
perl -pi -e 's/^.{1,3}$//g' wiki_*
echo ""

echo "Merging and Sorting Word lists"
bash -c "sort -u -S 30% wiki_* > $FILERESULT"
mv $FILERESULT ../$FILERESULT
cd ..
echo ""

echo "Cleaning temporary file"
rm -rf wikitmp
echo ""

echo "Operation Completed"
echo "WordLists Dictionary  "$FILERESULT" Succesfully Created."
echo ""
