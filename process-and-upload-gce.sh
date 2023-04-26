#!/usr/bin/env bash
set -euox pipefail

img_path=$(echo $1/*.tar.gz)
img_name=$(./gce_filename.sh $1)

if ! gsutil ls "gs://${BUCKET_NAME}/$img_name"; then
  gsutil cp "$img_path" "gs://${BUCKET_NAME}/$img_name"
  gsutil acl ch -u AllUsers:R "gs://${BUCKET_NAME}/$img_name"
fi
