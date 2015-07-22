{ stdenv, fetchurl, pkgconfig, wayland, mesa, libxkbcommon, cairo, libxcb
, libXcursor, x11, udev, libdrm, mtdev, libjpeg, pam, dbus, libinput
, pango ? null, libunwind ? null, freerdp ? null, vaapi ? null, libva ? null
, libwebp ? null, xwayland ? null
# beware of null defaults, as the parameters *are* supplied by callPackage by default
}:

stdenv.mkDerivation rec {
  name = "weston-${version}";
  version = "1.8.0";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "04nkbbdglh0pqznxkdqvak3pc53jmz24d0658bn5r0cf6agycqw9";
  };

  buildInputs = [
    pkgconfig wayland mesa libxkbcommon cairo libxcb libXcursor x11 udev libdrm
    mtdev libjpeg pam dbus.libs libinput pango libunwind freerdp vaapi libva
    libwebp
  ];

  configureFlags = [
    "--enable-x11-compositor"
    "--enable-drm-compositor"
    "--enable-wayland-compositor"
    "--enable-headless-compositor"
    "--enable-fbdev-compositor"
    "--enable-screen-sharing"
    "--enable-clients"
    "--enable-weston-launch"
    "--disable-setuid-install" # prevent install target to chown root weston-launch, which fails
  ] ++ stdenv.lib.optional (freerdp != null) "--enable-rdp-compositor"
    ++ stdenv.lib.optional (vaapi != null) "--enabe-vaapi-recorder"
    ++ stdenv.lib.optionals (xwayland != null) [
        "--enable-xwayland"
        "--with-xserver-path=${xwayland}/bin/Xwayland"
      ];

  meta = with stdenv.lib; {
    description = "Reference implementation of a Wayland compositor";
    homepage = http://wayland.freedesktop.org/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
