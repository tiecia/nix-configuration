{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    helvetica-neue-lt-std
    liberation_ttf
    # aileron
  ];
}
