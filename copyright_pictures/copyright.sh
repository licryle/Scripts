#!/bin/bash

for file in $(find $1 -maxdepth 1 -type f | grep -i \.jpg$)
do
  if [[ -f $file ]]; then
    filename=$(basename "$file")
    ./copyright_picture.sh $file ${2}$filename "$3" $4
  fi
done

#read -p "Press any key to continue..." -n1 -s
