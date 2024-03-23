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
}
