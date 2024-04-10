{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    partition-manager
  ];
}
