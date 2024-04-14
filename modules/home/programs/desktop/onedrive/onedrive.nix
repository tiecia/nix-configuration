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

    home.file.".config/onedrive/accounts/Personal/sync_list.txt".source = ./sync_list;

    # home.file.".config/onedrive/accounts/Personal/sync_list".source = pkgs.writeTextFile {
    #   name = "sync_list";
    #   text = ''
    #     !/Documents/2008 Nordhavn 64 PERSEVERANCE
    #     !/Documents/Backups

    #     /Documents'';
    # };

    systemd.user.services.onedrive = {
      Unit = {
        Description = "OneDrive Service";
      };
      Install = {
        WantedBy = ["default.target"];
      };
      Service = {
        ExecStart = "${pkgs.onedrive}/bin/onedrive --monitor";
      };
    };
  };
}
