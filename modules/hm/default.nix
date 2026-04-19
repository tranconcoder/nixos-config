{ lib, ... }:

{
  imports = [
    ./hyprland.nix
    ./kitty.nix
    ./theme.nix
    ./fcitx5.nix
  ];

  hydenix.hm = {
    enable = true;
    hyde.enable = true;
    hyprland.enable = true;
    dolphin.enable = true;

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

  home.file = {
    ".config/hypr/nvidia.conf".text = "";
  };
}
