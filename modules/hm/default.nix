{ lib, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./kitty.nix
    ./theme.nix
    ./fcitx5.nix
    ./nvim.nix
  ];

  hydenix.hm = {
    enable = true;
    hyde.enable = true;
    hyprland.enable = true;
    dolphin.enable = true;
    firefox.enable = false;

    terminals.kitty.enable = true;
    git.enable = true;
    editors = {
      enable = true;
      neovim = true;
    };
    rofi.enable = true;
    waybar.enable = true;
    swww.enable = true;
    theme = {
      enable = true;
      active = "Catppuccin Latte";
      themes = [ "Catppuccin Mocha" "Catppuccin Latte" ];
    };
  };

  home.packages = [
    pkgs.pnpm
    pkgs.bun
  ];

  programs.zsh = {
    enable = true;
    initExtra = ''
      # Clear screen truly (not scroll down)
      clear() { printf "\033[2J\033[H\033[3J"; }
    '';
  };

  home.file = {
    ".config/hypr/nvidia.conf".text = "";
  };
}
