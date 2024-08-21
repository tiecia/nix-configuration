{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.gnupg.agent.enable = lib.mkDefault true;
}
