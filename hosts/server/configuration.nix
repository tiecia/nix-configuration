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
  ];

  rebuild.host = "server";
  networking.hostName = lib.mkForce "TyServer";

  ssh.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [32772];
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      hello-world = {
        image = "nginxdemos/hello";
        ports = ["127.0.0.1:3010:80"];
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
