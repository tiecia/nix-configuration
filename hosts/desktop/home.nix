{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home/programs/cli
    ../../modules/home/programs/desktop
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tiec";
  home.homeDirectory = "/home/tiec";

  spotify = {
    enable = true;
    theme = "dark-blue";
  };

  git.enable = true;

  betterbird.enable = true;
  bitwarden.enable = true;
  chrome.enable = true;
  discord.enable = true;
  filezilla.enable = true;
  libreoffice.enable = true;
  msteams.enable = true;
  solaar.enable = true;
  # wine.enable = true;
  # kalc.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Install packages globally in the user profile.
  home.packages = with pkgs; [
    # hello
    devenv
    parsec-bin
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tiec/etc/profile.d/hm-session-vars.sh
  #

  # Add environment variables to the shell environment.
  home.sessionVariables = {
    # # This will add the 'MY_ENV_VAR' environment variable to your shell
    # # environment.
    # MY_ENV_VAR = "some value";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
