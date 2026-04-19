{
  description = "NixOS configuration with HyDE";

  inputs = {
    nixpkgs = {
      follows = "hydenix/nixpkgs";
    };
    hydenix.url = "github:richen604/hydenix";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nvim-v2.url = "github:tranconcoder/nvim-v2";
    nvim-v2.flake = false;
  };

  outputs = { ... }@inputs: {
    nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}