{stdenv, fetchurl, pkgconfig, glib, gperf, utillinux}:
let
  s = # Generated upstream information
  rec {
    baseName="eudev";
    version = "3.1.2";
    name="${baseName}-${version}";
    url="http://dev.gentoo.org/~blueness/eudev/eudev-${version}.tar.gz";
    sha256 = "0wq2w67ip957l5bi21jj3w2rv7s7klcrnlg6zpg1g0fxjfgbd4s3";
  };
  buildInputs = [
    glib pkgconfig gperf utillinux
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];
  makeFlags = [
    "hwdb_bin=/var/lib/udev/hwdb.bin"
    "udevrulesdir=/etc/udev/rules.d"
    ];
  installFlags =
    [
    "localstatedir=$(TMPDIR)/var"
    "sysconfdir=$(out)/etc"
    "udevconfdir=$(out)/etc/udev"
    "udevhwdbbin=$(out)/var/lib/udev/hwdb.bin"
    "udevhwdbdir=$(out)/var/lib/udev/hwdb.d"
    "udevrulesdir=$(out)/var/lib/udev/rules.d"
    ];
  enableParallelBuilding = true;
  meta = {
    inherit (s) version;
    description = ''An udev fork by Gentoo'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = ''http://www.gentoo.org/proj/en/eudev/'';
    downloadPage = ''http://dev.gentoo.org/~blueness/eudev/'';
    updateWalker = true;
  };
}
