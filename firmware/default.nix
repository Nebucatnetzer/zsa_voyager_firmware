# Taken from here: https://github.com/NobbZ/qmk_firmware/blob/main/firmware.nix
{
  avrdude,
  dfu-programmer,
  dfu-util,
  gcc-arm-embedded,
  git,
  pkgsCross,
  qmk,
  qmkSource,
  stdenv,
}:
let
  kb = "voyager";
  km = "default";
  version = "jZZQr4";
  firmwareSrc = ../source;
in
stdenv.mkDerivation {
  name = "${kb}_${km}_${version}.bin";

  buildInputs = [
    git
    qmk
    gcc-arm-embedded
    pkgsCross.avr.buildPackages.gcc8
    avrdude
    dfu-programmer
    dfu-util
  ];

  srcs = [
    qmkSource
    firmwareSrc
  ];
  sourceRoot = qmkSource.name;

  dontAutoPatchelf = true;

  unpackPhase = ''
    runHook preUnpack

    for s in $srcs; do
      dst=$(stripHash "$s")
      cp -rv "$s" "$dst"
      chmod -Rv +w $dst
    done

    runHook postUnpack
  '';

  configurePhase = ''
    mkdir -p keyboards/${kb}/keymaps
    cp -rv ../source keyboards/${kb}/keymaps/${km}
  '';

  buildPhase = ''
    qmk setup
    qmk compile -kb ${kb} -km ${km}
  '';

  installPhase = ''
    cp ${kb}_${km}.bin $out
  '';
}
