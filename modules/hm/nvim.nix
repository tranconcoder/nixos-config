{ lib, pkgs, ... }:

let
  # Local nvim config stored in flake
  nvimConfig = ./nvim-config;
in

{
  home.file = {
    ".config/nvim" = {
      source = nvimConfig;
      recursive = true;
    };
  };
}
