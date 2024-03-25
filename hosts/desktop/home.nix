{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home/programs/vscode.nix
    ../../modules/home/programs/git.nix
    ../../modules/home/programs/betterbird.nix
    ../../modules/home/programs/bitwarden.nix
    ../../modules/home/programs/cli-tools.nix
    ../../modules/home/programs/discord.nix
    ../../modules/home/programs/firefox.nix
    ../../modules/home/programs/git.nix
    ../../modules/home/programs/msteams.nix
    # ../../modules/home/programs/onedrive.nix
    ../../modules/home/programs/solaar.nix
    ../../modules/home/programs/spotify.nix
    ../../modules/home/programs/wireguard.nix
    ../../modules/home/programs/filezilla.nix
    # ../../modules/home/programs/kalc.nix
    # ../../modules/home/programs/wine.nix
    ../../modules/home/programs/libreoffice.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tiec";
  home.homeDirectory = "/home/tiec";

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
