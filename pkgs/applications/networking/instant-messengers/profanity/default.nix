{ stdenv, fetchurl, automake, autoconf, pkgconfig, glib, openssl, expat, ncurses, libotr, curl, libstrophe,
libnotifySupport ? false, libnotify ? null, libXScrnSaver ? null, libX11 ? null, gdk_pixbuf ? null}:

assert libnotifySupport -> (libnotify != null && libXScrnSaver != null && libX11 != null && gdk_pixbuf != null);

let
  optional = stdenv.lib.optional;
in
stdenv.mkDerivation rec {
  name = "profanity-${version}";
  version = "0.4.5";

  src = fetchurl {
    url = "http://www.profanity.im/profanity-${version}.tar.gz";
    sha256 = "0qzwqxcxf695z3gf94psd2x619vlp4hkkjmkrpsla1ns0f6v6dkl";
  };

  buildInputs = [ automake autoconf pkgconfig glib openssl expat ncurses libotr curl libstrophe ]
    ++ optional libnotifySupport [ libnotify libXScrnSaver libX11 gdk_pixbuf ];

  preConfigure = "sh bootstrap.sh";

  meta = {
    description = "A console based XMPP client";
    longDescription = ''
      Profanity is a console based XMPP client written in C using ncurses and
      libstrophe, inspired by Irssi.
    '';
    homepage = http://profanity.im/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
