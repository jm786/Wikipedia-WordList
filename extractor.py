#!/usr/bin/python3.7
####################################################
# Wordlist Extractor
####################################################
from tqdm import tqdm
from fsplit.filesplit import FileSplit
from multiprocessing import Pool
import sys
import os
import shutil

# Removal Method
def removal(filename):
    with open(filename, 'r+', encoding="UTF-8") as f:
        text = ''
        for line in f:
            if (len(line.strip()) != 0):
                newline = ''.join(c for c in line if c.isalnum()) + '\n'
                if (len(newline) > 4):
                    text += newline
                else:
                    continue
        f.seek(0)
        f.write(text)
        f.truncate()
    return


def main():
    print("Wikipedia Wordlist Extractor")
    xmlfile_path = sys.argv[1]
    pros = int(sys.argv[3])
    listname = sys.argv[2][:-4] + "-wordlist.txt"

    #################################################
    # Creating directory for storing splits if such a
    # directory does not already exists
    #################################################
    path = os.path.join(os.getcwd(), "wikisplits")

    try:
        os.mkdir(path)
    except OSError:
        print("Creation of the directory %s failed" % path)
    else:
        print("Wikisplits directory created")

    #################################################################
    # Splits up the file to facilitate data manipulation (size in MB)
    #################################################################
    print("Splitting file", listname, "...")
    fs = FileSplit(file=xmlfile_path, splitsize=5000000, output_dir=path)
    fs.split()

    print("File", xmlfile_path, "was split in directory", path)

    ###################################################
    # Proceeds to strip the files of characters, delete
    # smaller words, and clean up empty lines
    ###################################################

    # Removes all non-Alphanumeric Characters
    print("\nRemoving non-alphanumeric characters & words smaller than 4...")

    os.chdir(path)
    directory = os.getcwd()
    dirlist = sorted(os.listdir(directory))

    pool = Pool(processes=pros)
    for _ in tqdm(pool.imap(removal, dirlist), total=len(dirlist)):
        pass

    print("\nNon-Alphanumeric characters and words of size smaller than 4 removed.")

    ########################################################
    # Merges the lists back together, eliminating duplicates
    # and then deletes the 'wikisplit' directory.
    ########################################################
    print("\nMerging lists back")
    worddict = {}
    for file in sorted(os.listdir(directory)):
        with open(file, 'r+', encoding="UTF-8") as f:
            for line in tqdm(f):
                if (len(line.strip()) == 0):
                    continue
                worddict[line.strip()] = 1

    fileresult = open(listname, 'w', encoding="UTF-8")
    for word in tqdm(sorted(list(worddict.keys()))):
        fileresult.write(word + '\n')
    fileresult.close()

    os.chdir('..')
    shutil.move(os.path.join(path, listname), os.path.join(os.getcwd(), "wikilists"))

    print(listname + " has been created. It contains all the words from the wikipedia dump minus duplicates, and has also been sorted in ascending order.")

    try:
        shutil.rmtree(path)
    except Exception as e:
        print('%s ' % e)
    else:
        print('\n%s was deleted' % path)


if __name__ == '__main__':
    main()
