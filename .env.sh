#!/usr/bin/env bash

export TF_VAR_cloudflare_api_token=$(gcloud secrets versions access latest --secret=johnrinehart-dot-dev-cloudflare-api-token --project=webbie-295322)
export B2_APPLICATION_KEY_ID=$(gcloud secrets versions access latest --secret=backblaze-provisioner-key-id --project=webbie-295322)
export B2_APPLICATION_KEY=$(gcloud secrets versions access latest --secret=backblaze-provisioner-key --project=webbie-295322)
