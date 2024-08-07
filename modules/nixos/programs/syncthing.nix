{
  config,
  lib,
  inputs,
  ...
}: let
  # TODO: Get this from home manager
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
          overrideDevices = true;
          overrideFolders = true;

          settings = {
            inherit (secrets) gui devices;

            folders = {
              "prism" = {
                path = "/home/${username}/games/minecraft/prism";
                # devices = ["vault"];
                devices = ["sls" "vault" "sls-win" "TyDesktopNix" "TyDesktopWin" "SteamDeck"];
                id = "ehghj-uy2xj";
              };
              "documents" = {
                path = "/home/${username}/Documents";
                devices = ["sls" "vault" "sls-win" "TyDesktopNix" "TyDesktopWin"];
                id = "nmeir-v2pux";
              };
            };
          };
        };
      };
    };
  }
