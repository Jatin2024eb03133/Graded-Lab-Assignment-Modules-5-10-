#!/bin/bash

# 1) Check argument count
if [ $# -ne 1 ]; then
  echo "Usage: $0 <directory_path>"
  exit 1
fi

dir="$1"

# 2) Validate directory exists
if [ ! -d "$dir" ]; then
  echo "Error: Directory does not exist: $dir"
  exit 1
fi

# 3) Create backup folder inside given directory
backup="$dir/backup"
mkdir -p "$backup"

echo "Moving files from: $dir"
echo "Backup folder: $backup"
echo

# 4) Move each file in background
for f in "$dir"/*; do
  # skip if no files OR if it's the backup folder itself
  if [ ! -e "$f" ] || [ "$f" = "$backup" ]; then
    continue
  fi

  # only move regular files (not folders)
  if [ -f "$f" ]; then
    mv "$f" "$backup/" &
    pid=$!
    echo "Started moving $(basename "$f")  -> PID: $pid"
  fi
done
# 5) Wait for all background jobs to finish
echo
echo "Waiting for all background moves to finish..."
wait
echo "Done! All files moved."
