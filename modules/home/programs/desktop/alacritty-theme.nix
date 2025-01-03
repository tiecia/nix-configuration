{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  name = "alacritty-theme";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "95a7d695605863ede5b7430eb80d9e80f5f504bc";
    sha256 = "D37MQtNS20ESny5UhW1u6ELo9czP4l+q0S8neH7Wdbc=";
  };

  installPhase = ''
    cp -r . $out
  '';
}
