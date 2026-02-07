#!/bin/bash

# Check argument count (expects 1 file name)
if [ $# -ne 1 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

file="$1"

# Validate file exists + readable
if [ ! -f "$file" ]; then
  echo "Error: File '$file' not found."
  exit 1
fi

if [ ! -r "$file" ]; then
  echo "Error: File '$file' is not readable."
  exit 1
fi

# Convert text to one word per line:
# - lowercase
# - replace non-letters with newlines
# - remove empty lines
words=$(tr '[:upper:]' '[:lower:]' < "$file" | tr -cs '[:alpha:]' '\n' | sed '/^$/d')

# If file has no words
if [ -z "$words" ]; then
  echo "No words found in '$file'."
  exit 0
fi

# Longest word (sort by length, take last)
longest=$(printf "%s\n" "$words" | awk '{print length, $0}' | sort -n | tail -1 | cut -d" " -f2-)

# Shortest word (sort by length, take first)
shortest=$(printf "%s\n" "$words" | awk '{print length, $0}' | sort -n | head -1 | cut -d" " -f2-)

# Average word length
avg=$(printf "%s\n" "$words" | awk '{sum += length; count++} END {if(count>0) printf "%.2f", sum/count; else print "0"}')

# Unique word count
unique=$(printf "%s\n" "$words" | sort | uniq | wc -l)

echo "Longest word: $longest"
echo "Shortest word: $shortest"
echo "Average word length: $avg"
echo "Total unique words: $unique"
