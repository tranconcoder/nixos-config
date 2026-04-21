{ inputs, pkgs, lib, ... }:

{
  imports = [
    inputs.hydenix.inputs.home-manager.nixosModules.home-manager
    inputs.hydenix.nixosModules.default
    ./modules/system
    ./hardware-configuration.nix

    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [ pkgs.qt6Packages.fcitx5-unikey ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users.tvconss = { ... }: {
      imports = [
        inputs.hydenix.homeModules.default
        ./modules/hm
        {
          home.file = {
            ".env".text = ''
              # OpenCode MCP API Keys
              CONTEXT7_API_KEY=
              MEM0_API_KEY=
            '';
            ".config/opencode/opencode.json".text = ''
              {
                "$schema": "https://opencode.ai/config.json",
                "mcp": {
                  "context7": {
                    "type": "remote",
                    "url": "https://mcp.context7.com/mcp"
                  }
                }
              }
            '';
            
          };
        }
      ];
    };
  };

  users.users.tvconss = {
    isNormalUser = true;
    initialPassword = "tvconss";
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    google-chrome
    opencode
    mission-center
    kdePackages.kate
    vscode-with-extensions
    antigravity
    wlsunset
    lazygit
    vlc
    dbeaver-bin
    postman
    _7zz
    nodejs_22
    bun
  ];

  hydenix = {
    enable = true;
    hostname = "nixos";
    timezone = "Asia/Ho_Chi_Minh";
    locale = "en_US.UTF-8";
  };

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  system.stateVersion = lib.mkForce "25.11";
}
