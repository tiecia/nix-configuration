{
  config,
  lib,
  pkgs,
  ...
}: let
  alacritty-theme = pkgs.callPackage ./alacritty-theme.nix {};
in
  with lib; {
    options = {
      alacritty.enable = lib.mkEnableOption "Enable alacritty";
    };

    config = mkIf config.alacritty.enable {
      # home.packages = with pkgs; [
      #   alacritty
      # ];

      programs.alacritty = {
        enable = true;
        # settings = lib.mkForce {
        #   general.import = [
        #     "alacritty-theme/themes/gruvbox_dark.toml"
        #   ];
        #   window = {
        #     startup_mode = "Maximized";
        #     opacity = 0.9;
        #   };
        #   font = {
        #     size = 12;
        #     normal = {
        #       family = "DejaVuSansMono";
        #     };
        #   };
        # };
      };

      home.file = {
        ".config/alacritty/alacritty-theme" = {
          source = alacritty-theme;
          force = true;
        };
      };
    };
  }
