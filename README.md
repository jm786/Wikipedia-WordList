# Wikipedia Wordlist
![wiki-wordlist](https://img.shields.io/github/repo-size/jm786/Wikipedia-Wordlist?style=flat)

These scripts allow you to generate a single wordlist from every wiki in every language available in the wikimedia dumps.

The only expected result should be a rather large text file, anything else should be considered the result of a bug.

## Installation
Simply clone this repository and navigate to the folder that corresponds to your use case ([Unix](#unix), [Non-Unix](#non-unix)) and use the appropriate script.

## Unix
For Unix use cases the namescraper remains a python file but you now have access to a perl script for the extractor and 2 distro specific wiki-combinator files (CentOS and Ubuntu).
### Example
```bash
sh wiki-combinator[distroname].sh
```

## Non-Unix
For Non-Unix use cases all files are written in python which should allow for easy use on all platforms (Note these were written with python3.7 in mind).
```DOS
python3.7 wiki-combinator.py
```

## Acknowledgement
Although I wrote most of this I picked up the original idea from [ewinnk](https://github.com/ewwink/wikipedia-wordlists-extractor) for the extractor.
