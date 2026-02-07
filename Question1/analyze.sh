#!/bin/bash
if [ $# -ne 1 ]; then
echo "Error: Provide exactly one arguement."
exit 1
fi

path="$1"

if [ ! -e "$path" ]; then
echo "Error: Path does not exist."
exit 1
fi

if [ -f "$path" ]; then
echo "File status (lines words chars):"
wc "$path"

elif [ -d "$path" ]; then
echo "Directory status;"
total_files=$(find "$path" -maxdepth 1 -type f | wc -l)
txt_files=$(find "$path" -maxdepth 1 -type f -name "*.txt" | wc -l)
echo "Total files: $total_files"
echo "TXT files: $txt_files"
else
echo "Error: Invalid input."
fi
