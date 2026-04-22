{ pkgs, ... }:

let
  nvimRepo = builtins.fetchGit {
    url = "https://github.com/tranconcoder/nvim-v2";
    ref = "main";
  };
  nvimConfig = pkgs.runCommand "nvim-config" {} ''
    cp -rL ${nvimRepo} $out
    chmod -R +w $out
    rm -rf $out/src
  '';
in

{
  home.file = {
    ".config/nvim" = {
      source = nvimConfig;
      recursive = true;
    };
  };
}