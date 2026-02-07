#!/bin/bash

file="marks.txt"

if [ ! -f "$file" ]; then
  echo "File not found!"
  exit 1
fi

one_fail=0
all_pass=0

echo "Students who failed exactly ONE subject:"
echo "--------------------------------------"

while IFS=',' read -r roll name m1 m2 m3
do
  fail=0

  [ "$m1" -lt 33 ] && fail=$((fail+1))
  [ "$m2" -lt 33 ] && fail=$((fail+1))
  [ "$m3" -lt 33 ] && fail=$((fail+1))

  if [ "$fail" -eq 1 ]; then
    echo "$name"
    one_fail=$((one_fail+1))
  fi

  if [ "$fail" -eq 0 ]; then
    all_pass=$((all_pass+1))
  fi

done < "$file"

echo
echo "Students who passed ALL subjects:"
echo "--------------------------------"
grep -E '^[^,]+,[^,]+,([3-9][3-9]|[4-9][0-9]),([3-9][3-9]|[4-9][0-9]),([3-9][3-9]|[4-9][0-9])' marks.txt | cut -d',' -f2

echo
echo "Count failed in exactly one subject: $one_fail"
echo "Count passed all subjects: $all_pass"
