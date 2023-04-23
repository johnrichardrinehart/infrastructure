#!/usr/bin/env bash

export TF_VAR_cloudflare_api_token=$(gcloud secrets versions access latest --secret=johnrinehart-dot-dev-cloudflare-api-token --project=webbie-295322)
