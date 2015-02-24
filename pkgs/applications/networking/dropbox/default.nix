{ stdenv, fetchurl, makeDesktopItem
, dbus_libs, gcc, glib, libdrm, libffi, libICE, librsync, libSM
, libX11, libXmu, ncurses, popt, qt5, zlib
}:

# this package contains the daemon version of dropbox
# it's unfortunately closed source
#
# note: the resulting program has to be invoced as
# 'dropbox' because the internal python engine takes
# uses the name of the program as starting point.
#
# todo: dropbox is shipped with some copies of libraries.
# replace these libraries with the appropriate ones in
# nixpkgs.

let
  arch = if stdenv.system == "x86_64-linux" then "x86_64"
    else if stdenv.system == "i686-linux" then "x86"
    else throw "Dropbox client for: ${stdenv.system} not supported!";

  interpreter = if stdenv.system == "x86_64-linux" then "ld-linux-x86-64.so.2"
    else if stdenv.system == "i686-linux" then "ld-linux.so.2"
    else throw "Dropbox client for: ${stdenv.system} not supported!";

  version = "3.2.6";
  sha256 = if stdenv.system == "x86_64-linux" then "1pih4dgqsxx9s8vjmn49qdrrgfkkw8wl3m68x7mdz6wqb4lj3sry"
    else if stdenv.system == "i686-linux" then "0nnxj32xvhn312a16fhhxjf0brbivaw6m0s8d8qdn44qmg9fr4bz"
    else throw "Dropbox client for: ${stdenv.system} not supported!";

  # relative location where the dropbox libraries are stored
  appdir = "opt/dropbox";

  ldpath = stdenv.lib.makeSearchPath "lib"
    [
      dbus_libs gcc glib libdrm libffi libICE librsync libSM libX11
      libXmu ncurses popt qt5.base qt5.declarative qt5.webkit
      zlib
    ];

  desktopItem = makeDesktopItem {
    name = "dropbox";
    exec = "dropbox";
    comment = "Online directories";
    desktopName = "Dropbox";
    genericName = "Online storage";
    categories = "Application;Internet;";
  };

in stdenv.mkDerivation {
  name = "dropbox-${version}-bin";
  src = fetchurl {
    name = "dropbox-${version}.tar.gz";
    url = "https://dl-web.dropbox.com/u/17/dropbox-lnx.${arch}-${version}.tar.gz";
    inherit sha256;
  };

  sourceRoot = ".";

  patchPhase = ''
    rm -f .dropbox-dist/dropboxd
  '';

  installPhase = ''
    mkdir -p "$out/${appdir}"
    cp -r ".dropbox-dist/dropbox-lnx.${arch}-${version}"/* "$out/${appdir}/"
    mkdir -p "$out/bin"
    ln -s "$out/${appdir}/dropbox" "$out/bin/dropbox"

    rm "$out/${appdir}/libdrm.so.2"
    rm "$out/${appdir}/libffi.so.6"
    rm "$out/${appdir}/libicudata.so.42"
    rm "$out/${appdir}/libicui18n.so.42"
    rm "$out/${appdir}/libicuuc.so.42"
    rm "$out/${appdir}/libGL.so.1"
    rm "$out/${appdir}/libpopt.so.0"
    rm "$out/${appdir}/libQt5Core.so.5"
    rm "$out/${appdir}/libQt5DBus.so.5"
    rm "$out/${appdir}/libQt5Gui.so.5"
    rm "$out/${appdir}/libQt5Network.so.5"
    rm "$out/${appdir}/libQt5OpenGL.so.5"
    rm "$out/${appdir}/libQt5PrintSupport.so.5"
    rm "$out/${appdir}/libQt5Qml.so.5"
    rm "$out/${appdir}/libQt5Quick.so.5"
    rm "$out/${appdir}/libQt5Sql.so.5"
    rm "$out/${appdir}/libQt5WebKit.so.5"
    rm "$out/${appdir}/libQt5WebKitWidgets.so.5"
    rm "$out/${appdir}/libQt5Widgets.so.5"
    rm "$out/${appdir}/librsync.so.1"
    rm "$out/${appdir}/libX11-xcb.so.1"

    rm -fr "$out/${appdir}/plugins"

    find "$out/${appdir}" -type f -a -perm +0100 \
      -print -exec patchelf --set-interpreter ${stdenv.glibc}/lib/${interpreter} {} \;

    RPATH=${ldpath}:${gcc.cc}/lib:$out/${appdir}
    echo "updating rpaths to: $RPATH"
    find "$out/${appdir}" -type f -a -perm +0100 \
      -print -exec patchelf --force-rpath --set-rpath "$RPATH" {} \;

    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* $out/share/applications
  '';

  meta = {
    homepage = "http://www.dropbox.com";
    description = "Online stored folders (daemon version)";
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
