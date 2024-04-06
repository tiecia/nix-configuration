{
  config,
  pkgs,
  ...
}: {
  # pkgs.firefox = {
  #   extraNativeMessagingHosts = [
  #     pkgs.firefoxpwa
  #   ];
  # };

  programs.firefox.nativeMessagingHosts.packages = [pkgs.firefoxpwa];

  home.packages = with pkgs; [
    firefox
  ];
}
