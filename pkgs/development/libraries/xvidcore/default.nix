{ stdenv, fetchurl, yasm, autoconf, automake, libtool }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "xvidcore-${version}";
  version = "1.3.3";
  
  src = fetchurl {
    url = "http://downloads.xvid.org/downloads/${name}.tar.bz2";
    sha256 = "0m5g75qvapr7xpywg6a83v5x19kw1nm9l2q48lg7jvvpba0bmqdh";
  };

  preConfigure = ''
    # Configure script is not in the root of the source directory
    cd build/generic
  '' + optionalString stdenv.isDarwin ''
    # Undocumented darwin hack
    substituteInPlace configure --replace "-no-cpp-precomp" ""
  '';

  configureFlags = [ ]
    # Undocumented darwin hack (assembly is probably disabled due to an
    # issue with nasm, however yasm is now used)
    ++ optional stdenv.isDarwin "--enable-macosx_module --disable-assembly";

  nativeBuildInputs = [ ]
    ++ optional (!stdenv.isDarwin) yasm;

  buildInputs = [ ]
    # Undocumented darwin hack
    ++ optionals stdenv.isDarwin [ autoconf automake libtool ];

  # Don't remove static libraries (e.g. 'libs/*.a') on darwin.  They're needed to
  # compile ffmpeg (and perhaps other things).
  postInstall = optionalString (!stdenv.isDarwin) ''
    rm $out/lib/*.a
  '';
  
  meta = {
    description = "MPEG-4 video codec for PC";
    homepage    = https://www.xvid.com/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel lovek323 ];
    platforms   = platforms.all;
  };
}

