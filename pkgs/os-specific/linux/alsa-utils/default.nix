{stdenv, fetchurl, alsaLib, gettext, ncurses}:

stdenv.mkDerivation rec {
  name = "alsa-utils-1.0.26";

  src = fetchurl {
    # url = "ftp://ftp.alsa-project.org/pub/utils/${name}.tar.bz2";
    url = "http://gd.tuwien.ac.at/opsys/linux/alsa/utils/${name}.tar.bz2";
    sha256 = "1rw1n3w8syqky9i7kwy5xd2rzfdbihxas32vwfxpb177lqx2lpzq";
  };

  buildInputs = [ alsaLib ncurses ];
  buildNativeInputs = [ gettext ];

  configureFlags = "--disable-xmlto --with-udev-rules-dir=$(out)/lib/udev/rules.d";

  installFlags = "ASOUND_STATE_DIR=$(TMPDIR)/dummy";

  meta = {
    description = "ALSA, the Advanced Linux Sound Architecture utils";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    homepage = http://www.alsa-project.org/;
  };
}
