# TODO: Manage with homemanager
{
  config,
  pkgs,
  ...
}: let
  username = "tiec";
in {
  # environment.systemPackages = with pkgs; [
  #   syncthing
  # ];

  services = {
    syncthing = {
      enable = true;
      user = "${username}";
      dataDir = "/home/${username}/Documents"; # Default folder for new synced folders
      configDir = "/home/${username}/.config/syncthing"; # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
      overrideDevices = false;
      overrideFolders = false;

      settings.gui = {
        user = "ty";
        password = "uda8BYJ^Qu5N&R";
      };
    };
  };
}
