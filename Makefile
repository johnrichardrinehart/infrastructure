GCE_DIR := "./gce"

gce: clean-gce build-gce upload-gce update-gce

build-gce:
	nix build --tarball-ttl 0 --out-link $(GCE_DIR) github:johnrichardrinehart/JohnOS#gce

upload-gce:
	BOTO_CONFIG=$(shell pwd)/.boto BUCKET_NAME=johnrinehart-gce-images ./process-and-upload-gce.sh $(GCE_DIR)

update-gce:
	printf $(shell ./gce_filename.sh $(GCE_DIR)) > ./latest_gce

clean-gce:
	-unlink $(GCE_DIR) # https://stackoverflow.com/a/2670143/1477586
