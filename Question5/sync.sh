#!/bin/bash

dirA="dirA"
dirB="dirB"

# 1) Validate directories exist
if [ ! -d "$dirA" ]; then
  echo "Error: '$dirA' folder not found."
  exit 1
fi

if [ ! -d "$dirB" ]; then
  echo "Error: '$dirB' folder not found."
  exit 1
fi

echo "=== Files only in $dirA ==="
# -1 means suppress left column? actually: comm needs sorted input
comm -23 <(ls -1 "$dirA" | sort) <(ls -1 "$dirB" | sort)

echo
echo "=== Files only in $dirB ==="
comm -13 <(ls -1 "$dirA" | sort) <(ls -1 "$dirB" | sort)

echo
echo "=== Files in BOTH (content check) ==="
# common files
common_files=$(comm -12 <(ls -1 "$dirA" | sort) <(ls -1 "$dirB" | sort))

if [ -z "$common_files" ]; then
  echo "No common files."
  exit 0
fi

for f in $common_files; do
  fileA="$dirA/$f"
  fileB="$dirB/$f"

  # Check if both are regular files (skip folders)
  if [ -f "$fileA" ] && [ -f "$fileB" ]; then
    if cmp -s "$fileA" "$fileB"; then
      echo "$f : SAME"
    else
      echo "$f : DIFFERENT"
    fi
  else
    echo "$f : (skipped - not a regular file in both)"
  fi
done
