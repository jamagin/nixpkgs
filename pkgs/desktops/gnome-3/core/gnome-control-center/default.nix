{ fetchurl, stdenv, pkgconfig, gnome3, ibus, intltool, upower, makeWrapper
, libcanberra, accountservice, libpwquality, pulseaudio, fontconfig
, libxml2, polkit, libxslt, libgtop, libsoup, colord, colord-gtk, libxkbfile
, cracklib, python, krb5, networkmanagerapplet, libwacom, samba, libnotify
, shared_mime_info, tzdata, icu, libtool, docbook_xsl, docbook_xsl_ns }:

# http://ftp.gnome.org/pub/GNOME/teams/releng/3.10.2/gnome-suites-core-3.10.2.modules
# TODO: bluetooth, networkmanager, wacom, smbclient, printers

stdenv.mkDerivation rec {
  name = "gnome-control-center-3.10.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-control-center/3.10/${name}.tar.xz";
    sha256 = "1ac34kqkf174w0qc12p927dfhcm69xnv7fqzmbhjab56rn49wypn";
  };

  buildInputs = with gnome3;
    [ pkgconfig intltool ibus gtk glib upower libcanberra gsettings_desktop_schemas
      libxml2 gnome_desktop gnome_settings_daemon polkit libxslt libgtop gnome-menus
      gnome_online_accounts libsoup colord pulseaudio fontconfig colord-gtk libpwquality
      accountservice krb5 networkmanagerapplet libwacom samba libnotify libxkbfile
      shared_mime_info icu libtool docbook_xsl docbook_xsl_ns makeWrapper ];

  preBuild = ''
    substituteInPlace tz.h --replace "/usr/share/zoneinfo/zone.tab" "${tzdata}/share/zoneinfo/zone.tab"
    substituteInPlace panels/datetime/tz.h --replace "/usr/share/zoneinfo/zone.tab" "${tzdata}/share/zoneinfo/zone.tab"

    # hack to make test-endianess happy
    mkdir -p $out/share/locale
    substituteInPlace panels/datetime/test-endianess.c --replace "/usr/share/locale/" "$out/share/locale/"
  '';

  postInstall = with gnome3; ''
    wrapProgram $out/bin/gnome-control-center \
      --prefix XDG_DATA_DIRS : "${gsettings_desktop_schemas}/share:${gnome_settings_daemon}/share:${glib}/share:${gtk}/share:${colord}/share:$out/share"
    for i in $out/share/applications/*; do
      substituteInPlace $i --replace "gnome-control-center" "$out/bin/gnome-control-center"
    done
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
