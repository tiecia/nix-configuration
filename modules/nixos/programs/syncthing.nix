# TODO: Manage with homemanager
{
  config,
  pkgs,
  ...
}: let
  username = "tiec";
in {
  services = {
    syncthing = {
      enable = true;
      user = "${username}";
      dataDir = "/home/${username}/Documents"; # Default folder for new synced folders
      configDir = "/home/${username}/.config/syncthing"; # Folder for Syncthing's settings and keys
    };
  };
}
