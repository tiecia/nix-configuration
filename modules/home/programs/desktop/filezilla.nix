{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    filezilla
  ];
}
