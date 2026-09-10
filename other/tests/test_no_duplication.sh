#!/bin/bash

# Get all duplicate filenames
duplicates=$(find sync -type f -printf '%f\n' | sort | uniq -d)

if [ -n "$duplicates" ]; then
  echo "Error: duplicate filenames detected:"
  
  # Loop through each duplicate filename and print all its full paths
  while IFS= read -r filename; do
    find sync -type f -name "$filename"
  done <<< "$duplicates"
  
  exit 1
fi
