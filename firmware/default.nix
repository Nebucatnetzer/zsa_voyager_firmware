# Taken from here: https://github.com/NobbZ/qmk_firmware/blob/main/firmware.nix
{
  avrdude,
  dfu-programmer,
  dfu-util,
  gcc-arm-embedded,
  git,
  keymapSource,
  pkgsCross,
  qmk,
  qmkFirmware,
  stdenv,
}:
let
  kb = "voyager";
  km = "source";
  version = "jZZQr4";
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
    qmkFirmware
    keymapSource
  ];
  sourceRoot = qmkFirmware.name;

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
    qmk compile -kb ${kb} -km ${km}
  '';

  installPhase = ''
    cp ${kb}_${km}.bin $out
  '';
}
