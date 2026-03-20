#!/bin/bash
# I was sick of doing this series of steps to update discord when it would download a new .deb file so I scripted it.
# assumes you're running this from /home/<user> aka ~ 
cd ~/Downloads

newDiscord=$(printf '%s\n' discord-*.deb | sort --version-sort | tail -n 1)

# printf '%s\n' filename-*.txt: Expands the file pattern (e.g., filename-1.2.txt, filename-1.2.1.txt, filename-1.3.txt) and prints each match on a new line. This is safer than ls as it handles spaces and other special characters in filenames better.
# sort --version-sort (or sort -V): Sorts the input lines using a version sort algorithm, which correctly handles version strings (e.g., 1.2 comes before 1.10).
# tail -n 1: Outputs only the last line of the sorted list, which is the file with the highest version number. 

sudo apt install ./$newDiscord
