{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    onedrive
    onedrivegui
  ];
}
