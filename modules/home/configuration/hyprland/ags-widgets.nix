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
    widgetStartupScript = pkgs.pkgs.writeShellScriptBin "widgetStartupScript" ''
      ags
    '';
    mainMod = "Super"; # Inherit this from parent config?
  in
    lib.mkIf options.enable {
      wayland.windowManager.hyprland = {
        settings = {
          # exec-once = lib.mkBefore ''${widgetStartupScript}/bin/widgetStartupScript'';
          bind = [
            "${mainMod},${mainMod}_L, exec, ags -t launcher"
          ];
        };
      };

      home.packages = with pkgs; [
        bun
        dart-sass
        fd
        brightnessctl
        swww
        slurp
        wf-recorder
        wl-clipboard
        wayshot
        swappy
        hyprpicker
        pavucontrol
        networkmanager
        gtk3
        matugen
        inputs.matcha.packages.${system}.default
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
          widget-startup = "${pkgs.bash}/bin/bash ${widgetStartupScript}/bin/widgetStartupScript";
        };
      };
    };
}
