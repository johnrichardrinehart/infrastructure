#!/usr/bin/env bash
set -euo pipefail

img_path=$(echo $1/*.tar.gz)
extension="raw.tar.gz" # very hard to extract from the filename
filename="$(basename ${img_path%.raw.tar.gz})"

img_name=${IMAGE_NAME:-${filename}-$(sha256sum "${img_path}" | cut -f1 -d' ').${extension}}

echo $img_name
