#!/bin/bash

# 1) Check argument count
if [ $# -ne 1 ]; then
  echo "Usage: $0 <emails_file>"
  exit 1
fi

file="$1"

# 2) Check file exists and readable
if [ ! -f "$file" ]; then
  echo "Error: File '$file' does not exist."
  exit 1
fi

if [ ! -r "$file" ]; then
  echo "Error: File '$file' is not readable."
  exit 1
fi

# 3) Clear old output files
> valid.txt
> invalid.txt

# 4) Regex for valid emails: letters/digits + @ + letters + .com
regex='^[A-Za-z0-9]+@[A-Za-z]+\.com$'

# 5) Read file line by line
while IFS= read -r line; do
  # skip empty lines
  [ -z "$line" ] && continue

  if [[ "$line" =~ $regex ]]; then
    echo "$line" >> valid.txt
  else
    echo "$line" >> invalid.txt
  fi
done < "$file"

# 6) Remove duplicates from valid.txt
sort valid.txt | uniq > valid_temp.txt
mv valid_temp.txt valid.txt

echo "Done!"
echo "Valid emails saved in: valid.txt"
echo "Invalid emails saved in: invalid.txt"
