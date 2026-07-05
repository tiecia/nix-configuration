{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    widgets.delta.enable = lib.mkEnableOption "Enable delta-shell desktop widgets";
  };

  config = let
    options = config.widgets.delta;
    deltaShellStartup = pkgs.writeShellScript "deltaShellStartup" ''
      ${inputs.delta-shell.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/delta-shell run
    '';

    deltaShellStop = pkgs.writeShellScript "deltaShellStop" ''
      ${inputs.delta-shell.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/delta-shell quit
    '';

    deltaShellShowLauncher = pkgs.writeShellScript "deltaShellShowLauncher" ''
      ${inputs.delta-shell.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/delta-shell toggle applauncher
    '';
    mainMod = config.hyprland-conf.mainMod;
  in
    lib.mkIf options.enable {
      wayland.windowManager.hyprland = {
        settings = {
          # exec-once = lib.mkBefore ''${widgetStartupScript}/bin/widgetStartupScript'';
          bind = [
            "${mainMod},${mainMod}_L, exec, ${deltaShellShowLauncher}"
          ];
        };
      };

      systemd.user.services = {
        delta-shell-desktop-shell = {
          Unit = {
            Description = "delta-shell Desktop Shell";
          };
          Service = {
            Type = "simple";
            ExecStart = deltaShellStartup;
            ExecStop = deltaShellStop;
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
          Install = {
            WantedBy = ["graphical-session.target"];
          };
        };
      };
    };
}
