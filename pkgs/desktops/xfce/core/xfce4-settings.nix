{ stdenv, fetchurl, pkgconfig, intltool, exo, gtk, libxfce4util, libxfce4ui
, libglade, xfconf, xorg, libwnck, libnotify, libxklavier, garcon, upower }:

#TODO: optional packages
stdenv.mkDerivation rec {
  p_name  = "xfce4-settings";
  ver_maj = "4.12";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "108za1cmjslwzkdl76x9kwxkq8z734kg9nz8rxk057f10pqwxgh4";
  };

  name = "${p_name}-${ver_maj}.${ver_min}";

  patches = [ ./xfce4-settings-default-icon-theme.patch ];

  buildInputs =
    [ pkgconfig intltool exo gtk libxfce4util libxfce4ui libglade upower
      xfconf xorg.libXi xorg.libXcursor libwnck libnotify libxklavier garcon
    ];

  configureFlags = "--enable-pluggable-dialogs --enable-sound-settings";

  meta = {
    homepage = http://www.xfce.org/projects/xfce4-settings;
    description = "Settings manager for Xfce";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
