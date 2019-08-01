from tqdm import tqdm
import xml.dom.minidom as minidom
import bz2
import wget
import os
import urllib

url = "https://meta.wikimedia.org/wiki/Table_of_Wikimedia_projects"
try:
	wget.download(url, "Table_of_Wikimedia_projects.html")
except urllib.error.HTTPError as e:
	print("There was an error downloading %s: %s.\nThe table is not currently accessible.")

htmlpage = minidom.parse("Table_of_Wikimedia_projects.html")
rows = htmlpage.getElementsByTagName('tr')

wikipedia = []
wikitionary = []
wikibooks = []
wikinews = []
wikiquote = []
wikisource = []
wikiversity = []
wikivoyage = []

for row in tqdm(rows):
    for x in range(7, 22, 2):
        if (not row.childNodes[x].childNodes[0].hasChildNodes()):
            continue
        nodedata = str(row.childNodes[x].childNodes[0].childNodes[0].nodeValue).split(':')
        if (len(nodedata) < 2):
            continue
        elif (nodedata[0] == 'w'):
            wikipedia.append(nodedata[1] + 'wiki')
        elif (nodedata[0] == 'wikt'):
            wikitionary.append(nodedata[1] + 'wiktionary')
        elif (nodedata[0] == 'b'):
            wikibooks.append(nodedata[1] + 'wikibooks')
        elif (nodedata[0] == 'n'):
            wikinews.append(nodedata[1] + 'wikinews')
        elif (nodedata[0] == 'q'):
            wikiquote.append(nodedata[1] + 'wikiquote')
        elif (nodedata[0] == 's'):
            wikisource.append(nodedata[1] + 'wikisource')
        elif (nodedata[0] == 'v'):
            wikiversity.append(nodedata[1] + 'wikiversity')
        elif (nodedata[0] == 'voy'):
            wikivoyage.append(nodedata[1] + 'wikivoyage')

wikimedia = [wikipedia, wikitionary, wikibooks, wikinews, wikiquote, wikisource, wikiversity, wikivoyage]

for wikitype in tqdm(wikimedia):
    for wikiname in tqdm(sorted(wikitype)):
        print("\nDownloading %s-latest-pages-articles.xml.bz2" % wikiname)
        url = "https://dumps.wikimedia.org/%s/latest/%s-latest-pages-articles.xml.bz2" % (wikiname.strip(), wikiname.strip())
        try:
            filename = wget.download(url)
        except urllib.error.HTTPError as e:
            print("There was an error downloading %s: %s.\nIt is either a sample wiki or the dump is not currently accessible." % (wikiname, e))
        else:
            print("\nUnzipping %s" % filename)

        with open(filename[:-4], 'wb') as new_file, bz2.BZ2File(filename, 'rb') as file:
            for data in tqdm(iter(lambda: file.read(100 * 1024), b'')):
                new_file.write(data)

for file in sorted(os.listdir(os.getcwd())):
    if (file[-4:] == '.bz2'):
        os.remove(file)
