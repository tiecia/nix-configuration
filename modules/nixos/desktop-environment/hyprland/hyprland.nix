{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; {
  options = {
    hyprland.enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf config.hyprland.enable {
    plasma.enable = lib.mkForce false;

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    services = {
      xserver = {
        enable = true;
        libinput.enable = true;
        # displayManager.gdm = {
        #   enable = true;
        #   wayland = true;
        # };
      };

      gnome.gnome-keyring.enable = true;
    };

    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.sway}/bin/sway";
          user = "myuser";
        };
        default_session = initial_session;
      };
    };

    security = {
      polkit.enable = true;
      pam.services.ags = {};

      rtkit.enable = true; # Pipewire uses this to get process scheduling priority
    };

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    sound.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };
}
