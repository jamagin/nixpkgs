{ stdenv, requireFile, makeWrapper, which, zlib, mesa_noglu, glib, xorg, libxkbcommon
, xdg_utils
# For glewinfo
, libXmu, libXi, libXext }:

let
  packages = [
    stdenv.cc.cc zlib glib xorg.libX11 libxkbcommon libXmu libXi libXext
  ];
  libPath = "${stdenv.lib.makeLibraryPath packages}:${mesa_noglu.driverLink}/lib";
in
stdenv.mkDerivation rec {
  name = "genymotion-${version}";
  version = "2.7.2";
  src = requireFile {
    url = https://www.genymotion.com/account/login/;
    name = "genymotion-${version}-linux_x64.bin";
    sha256 = "0j1dzry6wf6cw3yr318z81rmj79r6w5l6vpilm7m9h786jrgywa1";
  };

  buildInputs = [ makeWrapper which xdg_utils ];

  unpackPhase = ''
    mkdir -p phony-home $out/share/applications
    export HOME=$TMP/phony-home

    mkdir ${name}
    echo "y" | sh $src -d ${name}
    sourceRoot=${name}

    substitute phony-home/.local/share/applications/genymobile-genymotion.desktop \
      $out/share/applications/genymobile-genymotion.desktop --replace "$TMP/${name}" "$out/libexec"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    mv genymotion $out/libexec/
    ln -s $out/libexec/genymotion/{genymotion,player} $out/bin
  '';

  fixupPhase = ''
    patchInterpreter() {
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        "$out/libexec/genymotion/$1"
    }

    patchExecutable() {
      patchInterpreter "$1"
      wrapProgram "$out/libexec/genymotion/$1" \
        --set "LD_LIBRARY_PATH" "${libPath}"
    }

    patchTool() {
      patchInterpreter "tools/$1"
      wrapProgram "$out/libexec/genymotion/tools/$1" \
        --set "LD_LIBRARY_PATH" "${libPath}"
    }

    patchExecutable genymotion
    patchExecutable player

    patchTool adb
    patchTool aapt
    patchTool glewinfo

    rm $out/libexec/genymotion/libxkbcommon*
  '';

  meta = {
    description = "Fast and easy Android emulation";
    longDescription = ''
      Genymotion is a relatively fast Android emulator which comes with
      pre-configured Android (x86 with OpenGL hardware acceleration) images,
      suitable for application testing.
     '';
    homepage = https://www.genymotion.com/;
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.puffnfresh ];
  };
}
