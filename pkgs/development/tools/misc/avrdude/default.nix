{ stdenv, fetchurl, yacc, flex, libusb, libelf, libftdi1, readline
# docSupport is a big dependency, disabled by default
, docSupport ? false, texLive ? null, texinfo ? null, texi2html ? null
}:

assert docSupport -> texLive != null && texinfo != null && texi2html != null;

stdenv.mkDerivation rec {
  name = "avrdude-6.1";

  src = fetchurl {
    url = "mirror://savannah/avrdude/${name}.tar.gz";
    sha256 = "0frxg0q09nrm95z7ymzddx7ysl77ilfbdix1m81d9jjpiv5bm64y";
  };

  configureFlags = stdenv.lib.optionalString docSupport "--enable-doc";

  buildInputs = [ yacc flex libusb libelf libftdi1 readline ]
    ++ stdenv.lib.optionals docSupport [ texLive texinfo texi2html ];

  meta = with stdenv.lib; {
    description = "Command-line tool for programming Atmel AVR microcontrollers";
    longDescription = ''
      AVRDUDE (AVR Downloader/UploaDEr) is an utility to
      download/upload/manipulate the ROM and EEPROM contents of AVR
      microcontrollers using the in-system programming technique (ISP).
    '';
    homepage = http://www.nongnu.org/avrdude/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
