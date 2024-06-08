{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    widgets.ags.enable = lib.mkEnableOption "Enable ags desktop widgets";
  };

  imports = [
    inputs.ags.homeManagerModules.default
  ];

  config = let
    options = config.widgets.ags;
    startupScript = pkgs.pkgs.writeShellScriptBin "startupScript" ''
      ${pkgs.ags}/bin/ags -b hypr
    '';
  in
    lib.mkIf options.enable {
      wayland.windowManager.hyprland = {
        settings = {
          exec-once = ''${startupScript}/bin/startupScript'';
        };
      };

      home.packages = with pkgs; [
        bun
        dart-sass
        fd
        brightnessctl
        swww
        inputs.matugen.packages.${system}.default
        slurp
        wf-recorder
        wl-clipboard
        wayshot
        swappy
        hyprpicker
        pavucontrol
        networkmanager
        gtk3
      ];

      programs.ags = {
        enable = true;
        configDir = ../../../../ags;
        extraPackages = with pkgs; [
          accountsservice
        ];
      };

      programs.bash = {
        enable = true;
        shellAliases = {
          widget-startup = "${pkgs.bash}/bin/bash ${startupScript}/bin/bash";
        };
      };
    };
}
