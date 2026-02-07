#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

file="$1"

if [ ! -f "$file" ]; then
  echo "File not found!"
  exit 1
fi

> vowels.txt
> consonants.txt
> mixed.txt

while read word; do
  w=$(echo "$word" | tr 'A-Z' 'a-z')

  if [[ $w =~ ^[aeiou]+$ ]]; then
    echo "$word" >> vowels.txt

  elif [[ $w =~ ^[^aeiou]+$ ]]; then
    echo "$word" >> consonants.txt

  elif [[ $w =~ ^[^aeiou].*[aeiou] ]]; then
    echo "$word" >> mixed.txt
  fi

done < "$file"

echo "Done! Files created:"
echo "vowels.txt"
echo "consonants.txt"
echo "mixed.txt"
