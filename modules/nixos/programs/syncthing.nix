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
      # user = "${username}";
      # dataDir = "/home/${username}/Documents"; # Default folder for new synced folders
      # configDir = "/home/${username}/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
      user = "tiec";
      dataDir = "/home/tiec/Documents"; # Default folder for new synced folders
      configDir = "/home/tiec/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
      settings.gui = {
        user = "ty";
        password = "uda8BYJ^Qu5N&R";
      };
    };
  };
}
