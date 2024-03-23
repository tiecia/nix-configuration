{
  config,
  pkgs,
  ...
}: {
  virtualisation.docker.enable = true;

  # Don't forget to give the user access to the docker
  # network group so it has access to the docker socket.
  # TODO: Figure out a way to do this here?
}
