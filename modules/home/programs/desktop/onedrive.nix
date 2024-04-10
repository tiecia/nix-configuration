{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    onedrive
    onedrivegui
  ];

  # services.onedrive.enable = true;

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
}
