# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/programs/cli
    ../../modules/nixos/configuration
    ../../modules/nixos/programs/server
  ];

  desktop-configuration.enable = lib.mkForce false;

  environment.systemPackages = [
    pkgs.jdk21
  ];

  rebuild.host = "server";
  networking.hostName = lib.mkForce "TyServer";

  # Reclaim the IDs used by the existing /srv/minecraft data, so the
  # Minecraft service account and group keep access across rebuilds.
  users.users.minecraft.uid = 993;
  users.groups.minecraft.gid = 991;
  users.users.tiec.extraGroups = ["minecraft"];

  # Keep the existing worlds and modpack in /srv/minecraft.
  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/srv/minecraft";

    servers = {
      vanilla = {
        enable = false;
        autoStart = false;
        openFirewall = false;
        jvmOpts = "-Xmx4G -Xms2G";
        package = pkgs.minecraftServers.vanilla-1_20_6;
      };

      all-the-mods = {
        enable = true;
        autoStart = true;
        openFirewall = false;
        jvmOpts = "-Xms4G -Xmx8G";
        # The modpack targets Java 21; nix-minecraft defaults to Java 25.
        package = pkgs.neoforgeServers."neoforge-1_21_1-21_1_186".override {
          jre_headless = pkgs.jdk21;
        };
      };
    };
  };

  home_assistant.enable = true;
  music_assistant.enable = true;
  snapserver.enable = false;
  # portracker.enable = true;

  # cloudflare-warp.enable = true;
  tailscale.enable = true;

  k3s.enable = true;

  ssh.enable = true;

  glances.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      25566 # All the Mods Minecraft server
      4566
      3000
      4000
      4532
      5555
    ];
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      hello-world = {
        image = "nginxdemos/hello";
        ports = ["0.0.0.0:3010:80"];
      };
    };
  };

  # From: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/headless.nix
  # Can I just import this file here somehow instead?

  # Don't start a tty on the serial consoles.
  systemd.services."serial-getty@ttyS0".enable = lib.mkDefault false;
  systemd.services."serial-getty@hvc0".enable = false;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@".enable = false;

  # Since we can't manually respond to a panic, just reboot.
  boot.kernelParams = [
    "panic=1"
    "boot.panic_on_fail"
    "vga=0x317"
    "nomodeset"
  ];

  # Don't allow emergency mode, because we don't have a console.
  systemd.enableEmergencyMode = false;

  # Being headless, we don't need a GRUB splash image.
  boot.loader.grub.splashImage = null;
  # End from: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/headless.nix

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
