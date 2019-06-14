####################################################
# Wordlist Extractor
####################################################
from tqdm import tqdm
from fsplit.filesplit import FileSplit
from multiprocessing import Pool
import sys
import os
import regex as re
import shutil

# Removal Method
def removal(arguments):
    args = arguments.split(',')
    regex = re.compile(args[0])

    with open(args[2], 'r+', encoding="UTF-8") as f:
        text = ''
        for line in f:
            if (int(args[3]) == 1):
                if (len(line.strip()) != 0):
                    text += regex.sub(args[1], line)
            if (int(args[3]) == 2):
                if (len(line.strip()) >= 4):
                    text += line
        f.seek(0)
        f.write(text)
        f.truncate()
    return


def main():
    print("Wikipedia Wordlist Extractor")
    xmlfile_path = os.path.join(sys.argv[2], sys.argv[1])
    pros = int(sys.argv[3])
    print(sys.argv[3])
    print(sys.argv[2])
    listname = sys.argv[1][:-4] + "-wordlist.txt"

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

    return
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
    print("\nRemoving non-Alphanumeric Characters...")

    os.chdir(path)
    directory = os.getcwd()
    dirlist = sorted(os.listdir(directory))
    pattern = r'[\p{S}\p{P}\p{Z}]'
    arguments = []

    for file in dirlist:
        arguments.append(pattern+',\n,'+file+',1')

    pool = Pool(processes=pros)
    for _ in tqdm(pool.imap(removal, arguments), total=len(arguments)):
        pass

    print("\nNon-Alphanumeric Characters removed")

    # Deletes all words smaller than 4 characters
    print("\nRemoving all words smaller than 4 characters...")

    pattern = r'\b[a-zA-Z0-9]{3}\b'
    arguments = []
    for file in dirlist:
        arguments.append(pattern+',\n,'+file+',2')

    pool = Pool(processes=pros)
    for _ in tqdm(pool.imap(removal, arguments), total=len(arguments)):
        pass

    print("\nAll words smaller than 4 characters removed")

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
