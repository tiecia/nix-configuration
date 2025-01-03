{
  config,
  lib,
  pkgs,
  stdenv,
  ...
}: let
  alacritty-theme = pkgs.callPackage ./alacritty-theme.nix {};
in
  with lib; {
    options = {
      alacritty.enable = lib.mkEnableOption "Enable alacritty";
    };

    config = mkIf config.alacritty.enable {
      home.packages = with pkgs; [
        alacritty
      ];

      home.file = {
        ".config/alacritty/alacritty-theme".source = alacritty-theme;
        #   source = alacritty-theme;
        # };
      };
    };
  }
