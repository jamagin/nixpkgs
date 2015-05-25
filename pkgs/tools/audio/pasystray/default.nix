{stdenv, fetchurl, unzip, autoconf, automake, makeWrapper, pkgconfig
, gnome3, avahi, gtk3, libnotify, pulseaudio, x11}:

stdenv.mkDerivation rec {
  name = "pasystray-0.4.0";

  src = fetchurl {
    url = "https://github.com/christophgysin/pasystray/archive/${name}.zip";
    sha256 = "0n41qm04kilhc827yx8y1ijslmajg2dxykaf3s3aq6s6bjzzw8bh";
  };

  buildInputs = [ unzip autoconf automake makeWrapper pkgconfig 
                  gnome3.defaultIconTheme
                  avahi gtk3 libnotify pulseaudio x11 ];

  preConfigure = ''
    aclocal
    autoconf
    autoheader
    automake --add-missing
  '';

  preFixup = ''
    wrapProgram "$out/bin/pasystray" \
      --prefix XDG_DATA_DIRS : "${gnome3.defaultIconTheme}/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "PulseAudio system tray";
    homepage = "https://github.com/christophgysin/pasystray";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.exlevan ];
    platfoms = platforms.linux;
  };
}
