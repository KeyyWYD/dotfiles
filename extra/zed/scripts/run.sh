#!/usr/bin/env bash

# Access the full path using ZED_FILE
full_path="$ZED_FILE"

# Extract filename with extension
filename_ext=$(basename "$full_path")

# Extract filename and extension
filename="${filename_ext%.*}"
extension="${filename_ext##*.}"

# C/C++ output directory
output_dir="$(dirname "$full_path")/$(basename "$filename")"

[ ! -d "$output_dir" ] && mkdir -p "$output_dir"

echo "[Running $filename_ext]"

if [ "$extension" == "c" ]; then
  gcc -Wall "$full_path" -o "$output_dir/$filename" && "$output_dir/$filename"
elif [ "$extension" == "cpp" ]; then
  g++ -Wall "$full_path" -o "$output_dir/$filename" && "$output_dir/$filename"
elif [ "$extension" == "py" ]; then
  python3 "$full_path"
elif [ "$extension" == "sh" ]; then
  bash "$full_path"
else
  echo "Unsupported file type."
fi
