{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    ags.enable = lib.mkEnableOption "Enable ags";
  };

  imports = [
    inputs.ags.homeManagerModules.default
  ];

  config = lib.mkIf config.ags.enable {
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
  };
}
