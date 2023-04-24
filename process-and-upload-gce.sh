#!/usr/bin/env bash
set -euox pipefail

img_path=$(echo gce/*.tar.gz)
img_name=${IMAGE_NAME:-$(basename "$img_path")}
img_id=$(echo "$img_name" | sed 's|.raw.tar.gz$||;s|\.|-|g;s|_|-|g')
img_family=$(echo "$img_id" | cut -d - -f1-4)

#if ! gsutil ls "gs://${BUCKET_NAME}/$img_name"; then
  gsutil cp "$img_path" "gs://${BUCKET_NAME}/$img_name"
  gsutil acl ch -u AllUsers:R "gs://${BUCKET_NAME}/$img_name"
#fi
