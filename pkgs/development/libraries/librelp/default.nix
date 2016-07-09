{ stdenv, fetchurl, pkgconfig, gnutls, zlib }:

stdenv.mkDerivation rec {
  name = "librelp-1.2.8";

  src = fetchurl {
    url = "http://download.rsyslog.com/librelp/${name}.tar.gz";
    sha256 = "1qxj7isa2d10aw6c4a9pd3fx08vv06rrhac312avgcjmdqaa88r6";
  };

  buildInputs = [ pkgconfig gnutls zlib ];

  meta = with stdenv.lib; {
    homepage = http://www.librelp.com/;
    description = "A reliable logging library";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
