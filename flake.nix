{
  description = "Infrastructure management for https://jpg.store and related services.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem flake-utils.lib.defaultSystems (system:
      let
        pkgs = (import nixpkgs {
          inherit system overlays;
        });

        terraformer =
          let
            version = "0.8.20";
            src = pkgs.fetchFromGitHub {
              owner = "GoogleCloudPlatform";
              rev = "${version}";
              repo = "terraformer";
              sha256 = "sha256-eKK7aFStYLBVpxyQdalzqpeaAhKRUaQH6fYPzLdEJDc=";
            };
            name = "terraformer-${version}";
          in
          (pkgs.callPackage "${pkgs.path}/pkgs/development/tools/misc/terraformer" {
            buildGoModule = args: pkgs.buildGoModule (args // {
              inherit name src version;
              vendorSha256 = "sha256-8k7Exb5Z5VWQ47tM6gvb9tqCWkbb9ZfS1yDZclQTKi8=";
            });
          });

        overlays = [
          (self: super: {
            inherit terraformer;
          })
        ];
      in
      rec {
        packages = flake-utils.lib.flattenTree {
          terraform = pkgs.terraform; # with plugins
          terraformer = pkgs.terraformer;
        };


        apps = {
          terraform = flake-utils.lib.mkApp { drv = packages.terraform; };
          terraformer = flake-utils.lib.mkApp { drv = packages.terraformer; };
        };

        defaultPackage = packages.terraform;
        defaultApp = apps.terraform;
      }
    );
}
