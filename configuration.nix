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

  networking.firewall.allowedTCPPorts = [ 8081 ];
  networking.firewall.allowedUDPPorts = [ 8081 ];

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
    users.tvconss = { config, lib, ... }: {
      imports = [
        inputs.hydenix.homeModules.default
        inputs.sops-nix.homeManagerModules.sops
        ./modules/hm
      ];

      sops = {
        age.keyFile = "/home/tvconss/.config/sops/age/keys.txt";
        defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
        secrets = {
          context7_api_key = {};
          mem0_api_key = {};
        };
      };

      home.activation.createEnvFile = lib.hm.dag.entryAfter ["writeBoundary"] ''
        rm -f ~/.env
        cat > ~/.env <<EOF
CONTEXT7_API_KEY=$(cat ${config.sops.secrets.context7_api_key.path})
MEM0_API_KEY=$(cat ${config.sops.secrets.mem0_api_key.path})
EOF
        chmod 600 ~/.env
      '';

      home.file = {
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
