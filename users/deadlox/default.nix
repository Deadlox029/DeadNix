{
  config,
  lib,
  pkgs,
  flake-inputs,
  ...
}:
let
  cfg = config.userconfig.deadlox;
in
{

  imports = [
    flake-inputs.home-manager.nixosModules.default
#    lazyvim.homeManagerModules.default
  ];

  options.userconfig.deadlox = {
    enable = lib.mkEnableOption "user deadlox";
    hostname = lib.mkOption {
      defaultText = "hostname of the current system";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.deadlox = {
      isNormalUser = true;
      description = "Dean Deist";
      extraGroups = [
        "networkmanager"
        "wheel"
        "wireshark"
      ];
      shell = pkgs.zsh;
      packages = with pkgs; [
        vscodium
        vscode
        neovim
        flatpak
        vlc
        kitty
        spotify
        gimp
        asdf-vm
      ];
    };
    fonts.packages = with pkgs; [
      nerd-fonts.comic-shanns-mono
      nerd-fonts.meslo-lg
      nerd-fonts.fira-code
    ];
    programs.lazyvim.enable = true;
    programs.zsh.enable = true;
    home-manager = {
      users.deadlox = ./home/home.nix;
      extraSpecialArgs = {
        inherit flake-inputs;
        userConfiguration = cfg;
      };
    };
  };
}
