{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    onedrive.enable = lib.mkEnableOption "Enable onedrive";
  };

  config = mkIf config.onedrive.enable {
    home.packages = with pkgs; [
      onedrive
      onedrivegui
    ];

    # https://github.com/abraunegg/onedrive/blob/master/docs/USAGE.md#performing-a-selective-sync-via-sync_list-file
    home.file.".config/onedrive/accounts/Personal/sync_list".source = ./sync_list;

    # Note: The service is started through Plasma starting the OneDriveGUI program on startup.
  };
}
