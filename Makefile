gce:
	nix build --out-link gce github:johnrichardrinehart/JohnOS#gce

upload:
	BUCKET_NAME=johnrinehart-gce-images ./process-and-upload-gce.sh
