{ stdenv, fetchurl, buildEnv, makeDesktopItem, makeWrapper, zlib, glib, alsaLib
, dbus, gtk, atk, pango, freetype, fontconfig, libgnome_keyring3, gdk_pixbuf
, cairo, cups, expat, libgpgerror, nspr, gconf, nss, xlibs, libcap
}:

let
  atomEnv = buildEnv {
    name = "env-atom";
    paths = [
      stdenv.cc.cc zlib glib dbus gtk atk pango freetype libgnome_keyring3
      fontconfig gdk_pixbuf cairo cups expat libgpgerror alsaLib nspr gconf nss
      xlibs.libXrender xlibs.libX11 xlibs.libXext xlibs.libXdamage xlibs.libXtst
      xlibs.libXcomposite xlibs.libXi xlibs.libXfixes xlibs.libXrandr
      xlibs.libXcursor libcap
    ];
  };
in stdenv.mkDerivation rec {
  name = "atom-${version}";
  version = "0.187.0";

  src = fetchurl {
    url = "https://github.com/atom/atom/releases/download/v${version}/atom-amd64.deb";
    sha256 = "0s6173dg5m52zc8kqwlgjn113d84cskrv9v29fb0nrvwvkv2xzmw";
    name = "${name}.deb";
  };

  buildInputs = [ atomEnv makeWrapper ];

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out
    ar p $src data.tar.gz | tar -C $out -xz ./usr
    mv $out/usr/* $out/
    rm -r $out/usr/
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/share/atom/atom
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/share/atom/resources/app/apm/bin/node
    wrapProgram $out/bin/atom \
      --prefix "LD_LIBRARY_PATH" : "${atomEnv}/lib:${atomEnv}/lib64"
    wrapProgram $out/bin/apm \
      --prefix "LD_LIBRARY_PATH" : "${atomEnv}/lib:${atomEnv}/lib64"
  '';

  meta = with stdenv.lib; {
    description = "A hackable text editor for the 21st Century";
    homepage = https://atom.io/;
    license = [ licenses.mit ];
    maintainers = [ maintainers.offline ];
    platforms = [ "x86_64-linux" ];
  };
}
