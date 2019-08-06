#!/usr/bin/python3.7
from tqdm import tqdm
import os
import shutil

print("Creating lists for all dumps in the folder")
master_path = os.path.abspath(os.getcwd())
path = os.path.join(os.getcwd(), "wikilists")

try:
    os.mkdir(path)
except OSError:
    print("Creation of the directory %s failed" % path)
else:
    print("Wikilists directory created")

# Add iteration over list of wikis to download
dump_path = os.path.join(os.getcwd(), "wikidumps")

try:
    os.mkdir(dump_path)
except OSError:
    print("Creation of the director %s failed" % dump_path)
else:
    print("Wikidumps directory created")

os.chdir(dump_path)
os.system('python3.7 %s' % (os.path.join(master_path, 'namescraper.py')))
os.chdir('..')

for file in sorted(os.listdir(dump_path)):
    if (file[-4:] == '.xml'):
        os.system('python3.7 extractor.py -n %s -f %s -p %s' % (file, dump_path, 15))

########################################################
# Merges the lists back together, eliminating duplicates
# and then deletes the 'wikisplit' directory.
########################################################
print("Merging lists together")

os.chdir(path)

# Reinstate code for Windows

finaldict = {}
for file in os.listdir(os.getcwd()):
    with open(file, 'r+', encoding="UTF-8") as f:
        for line in tqdm(f):
            if (len(line.strip()) == 0):
                continue
            finaldict[line.strip()] = 1

result_path = os.path.join(master_path, "wiki-extraction-wordlist.txt")
fileresult = open(result_path, 'w+', encoding="UTF-8")
fileresult.seek(0)
for word in tqdm(sorted(list(finaldict.keys()))):
    fileresult.write(word + '\n')
fileresult.close()


result_path = os.path.join(master_path, "wiki-extraction-wordlist-unsorted.txt")
with open(result_path, 'wb') as wfd:
    for file in sorted(os.listdir(os.getcwd())):
        with open(file, 'rb') as fd:
            shutil.copyfileobj(fd, wfd)

os.system('touch wiki-extraction-wordlist.txt')
os.system('sort wiki-extraction-wordlist-unsorted.txt | uniq > wiki-extraction-wordlist.txt')

os.chdir('..')
shutil.rmtree(path)
shutil.rmtree(dump_path)
shutil.rmtree(os.path.abspath("wikisplits"))

print("wiki-extraction-wordlist.txt has been created. It contains all the words from the wikipedia dumps in the folder.")
print(result_path)
