#!/bin/bash

#usage:
#./renamer <source-extention> <dest-extention>

SOURCE=$1
DEST=$2
for f in *.${SOURCE}; do 
   mv -- "$f" "${f%.${SOURCE}}.${DEST}"
done
