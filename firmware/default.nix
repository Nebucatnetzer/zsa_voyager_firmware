# Taken from here: https://github.com/NobbZ/qmk_firmware/blob/main/firmware.nix
{
  stdenv,
  fetchFromGitHub,
  zsa,
  qmk,
  git,
  gcc-arm-embedded,
  pkgsCross,
  avrdude,
  dfu-programmer,
  dfu-util,
}:
let
  firmware = fetchFromGitHub {
    name = "zsa-firmware-${zsa.rev}-source";
    owner = "zsa";
    repo = "qmk_firmware";
    inherit (zsa) rev;
    fetchSubmodules = true;
    sha256 = "sha256-J0lKc7bmwzwrKUx6q5CGZFTM4a1xvqgyCnpxBa9nFbI=";
  };

  kb = "voyager";
  km = "nobbz";

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
    firmware
    firmwareSrc
  ];
  sourceRoot = firmware.name;

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
