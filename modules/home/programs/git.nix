{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    git
    gitkraken
    git-credential-manager
  ];

  programs.git = {
    enable = true;
    userName = "tiecia";
    userEmail = "ty.cia@outlook.com";
    aliases = {
      co = "checkout";
      cm = "commit";
      st = "status";
      pu = "push";
    };
  };
}