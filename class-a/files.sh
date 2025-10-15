#!/bin/bash

# create some random files, zip them, and create it in a folder

num_files=20

# file types to make
extensions=(
    "txt" "docx" "rtf" "md" 
    "jpg" "png" "bmp" 
    "py" "sh" 
    "tar"
)

# put archives here
mkdir -p file_mgmt
cd file_mgmt

# make a bunch of files
for ext in "${extensions[@]}"; do
    for i in $(seq 1 $num_files); do
        touch "$RANDOM$RANDOM.$ext"
    done
done

# split files into zip archives
for i in {1..5}; do
    case $i in
        1) zip -q "archive_$i.zip" [01]* ;;
        2) zip -q "archive_$i.zip" [23]* ;;
        3) zip -q "archive_$i.zip" [45]* ;;
        4) zip -q "archive_$i.zip" [67]* ;;
        5) zip -q "archive_$i.zip" [89]* ;;
    esac
done

# remove the leftover files
rm *.txt *.docx *.rtf *.md *.jpg *.png *.bmp *.py *.sh *.tar 