{
  inputs,
  writeShellScript,
  system,
  stdenv,
  cage,
  swww,
  esbuild,
  dart-sass,
  fd,
  fzf,
  brightnessctl,
  accountsservice,
  slurp,
  wf-recorder,
  wl-clipboard,
  wayshot,
  swappy,
  hyprpicker,
  pavucontrol,
  networkmanager,
  gtk3,
  which,
  matugen,
}: let
  name = "asztal";

  agsPackages = inputs.ags.packages.${system};

  ags = agsPackages.default.override {
    extraPackages = [
      accountsservice
      agsPackages.astal3
      agsPackages.io
      agsPackages.apps
      agsPackages.auth
      agsPackages.battery
      agsPackages.bluetooth
      agsPackages.greet
      agsPackages.hyprland
      agsPackages.mpris
      agsPackages.network
      agsPackages.notifd
      agsPackages.powerprofiles
      agsPackages.tray
      agsPackages.wireplumber
    ];
  };

  dependencies = [
    which
    dart-sass
    fd
    fzf
    brightnessctl
    swww
    slurp
    wf-recorder
    wl-clipboard
    wayshot
    swappy
    hyprpicker
    pavucontrol
    networkmanager
    gtk3
    matugen
  ];

  addBins = list: builtins.concatStringsSep ":" (builtins.map (p: "${p}/bin") list);

  greeter = writeShellScript "greeter" ''
    export PATH=$PATH:${addBins dependencies}
    ${cage}/bin/cage -ds -m last ${ags}/bin/ags run ${config}/greeter.js
  '';

  desktop = writeShellScript name ''
    export PATH=$PATH:${addBins dependencies}
    if [ $# -eq 0 ]; then
      ${ags}/bin/ags -b ${name} run ${config}/config.js
    else
      ${ags}/bin/ags -b ${name} "$@"
    fi
  '';

  config = stdenv.mkDerivation {
    inherit name;
    src = ./.;

    buildPhase = ''
      ${esbuild}/bin/esbuild \
        --bundle ./main.ts \
        --outfile=main.js \
        --format=esm \
        --loader:.ts=tsx \
        --external:resource://\* \
        --external:gi://\* \

      ${esbuild}/bin/esbuild \
        --bundle ./greeter/greeter.tsx \
        --outfile=greeter.js \
        --format=esm \
        --loader:.ts=tsx \
        --external:resource://\* \
        --external:gi://\* \
    '';

    installPhase = ''
      mkdir -p $out
      cp -r assets $out
      cp -r style $out
      cp -r greeter $out
      cp -r widget $out
      cp -f main.js $out/config.js
      cp -f greeter.js $out/greeter.js
    '';
  };
in
  stdenv.mkDerivation {
    inherit name;
    src = config;

    installPhase = ''
      mkdir -p $out/bin
      cp -r . $out
      cp ${desktop} $out/bin/${name}
      cp ${greeter} $out/bin/greeter
    '';
  }
