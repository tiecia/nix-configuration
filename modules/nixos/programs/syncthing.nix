{
  config,
  lib,
  inputs,
  ...
}: let
  username = "tiec";
  secrets = import "${inputs.private}/secrets/syncthing.nix";
in
  with lib; {
    options = {
      syncthing.enable = mkEnableOption "Enable syncthing";
    };

    config = mkIf config.syncthing.enable {
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
            inherit (secrets) user password;
          };
        };
      };
    };
  }
