{ lib, pkgs, ... }:

let
  # Local nvim config stored in flake
  nvimConfig = ./nvim-config;
in

{
  home.activation.copyNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    rm -rf ~/.config/nvim
    cp -rL ${nvimConfig} ~/.config/nvim
    chmod -R +w ~/.config/nvim
    
    # Ensure parsers directory exists for treesitter
    mkdir -p ~/.local/share/nvim/lazy/nvim-treesitter/parser
  '';
}
