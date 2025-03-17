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
    services = {
      libinput.enable = true;
      xserver = {
        enable = true;
        displayManager.gdm = {
          enable = true;
          wayland = true;
          # autoSuspend = true;
        };
      };

      gnome.gnome-keyring.enable = true;
    };

    services = {
      gvfs.enable = true;
      udisks2.enable = true;
    };

    # services.greetd = {
    #   enable = true;
    #   settings = {
    #     command = "agreety --cmd $SHELL";
    # command = "hyprlock";
    # user = "tiec";
    #   };
    # };

    # services.greetd = {
    #   enable = true;
    #   settings = rec {
    #     initial_session = {
    #       # command = "${pkgs.sway}/bin/sway";
    #       command = pkgs.writeShellScriptBin "greeter" ''
    #         export XKB_DEFAULT_LAYOUT=${config.services.xserver.xkb.layout}
    #         export XCURSOR_THEME=Qogir
    #         export GTK_USE_PORTAL=0
    #         ${pkgs.sway}/bin/sway
    #       '';
    #       user = "myuser";
    #     };
    #     default_session = initial_session;
    #   };
    # };

    environment.systemPackages = [
      inputs.hyprland-display-tools.packages.${pkgs.system}.hyprland-display-tools
    ];

    security = {
      polkit.enable = true;
      pam.services = {
        ags = {};
        # hyprlock = {}; # Gives the homemanager-enabled hyperlock elevated privilages to work
      };

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

      services.hyprland-display-tools = {
        enable = true;
        description = "hyprland-display-tools";
        wantedBy = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          User = "tiec";
          # Group = "users";
          ExecStart = "${inputs.hyprland-display-tools.packages.${pkgs.system}.hyprland-display-tools}/bin/hyprland-display-tools";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
        environment = {
          # XDG_RUNTIME_DIR = "/run/user/1000";
          RUST_BACKTRACE = "full";
        };
      };
    };

    # sound.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    programs = {
      hyprland = {
        enable = true;
        xwayland.enable = true;
        # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      };
    };
  };
}
