{ stdenv, fetchurl, cmake, coreutils, freetype, gnused, pkgconfig, which }:

let version = "4.10.2.2614"; in
stdenv.mkDerivation rec {
  name = "squeak-${version}";

  src = fetchurl {
    sha256 = "0bpwbnpy2sb4gylchfx50sha70z36bwgdxraym4vrr93l8pd3dix";
    url = "http://squeakvm.org/unix/release/Squeak-${version}-src.tar.gz";
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "Smalltalk programming language and environment";
    longDescription = ''
      Squeak is a full-featured implementation of the Smalltalk programming
      language and environment based on (and largely compatible with) the
      original Smalltalk-80 system. Squeak has very powerful 2- and 3-D
      graphics, sound, video, MIDI, animation and other multimedia
      capabilities. It also includes a customisable framework for creating
      dynamic HTTP servers and interactively extensible Web sites.
    '';
    homepage = http://squeakvm.org/;
    downloadPage = http://squeakvm.org/unix/index.html;
    license = with licenses; [ asl20 mit ];
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ cmake coreutils freetype gnused pkgconfig which ];

  postPatch = ''
    for i in squeak.in squeak.sh.in; do
      substituteInPlace unix/cmake/$i --replace "PATH=" \
        "PATH=${coreutils}/bin:${gnused}/bin:${which}/bin #"
    done
  '';

  configurePhase = ''
    unix/cmake/configure --prefix=$out --enable-mpg-{mmx,pthreads}
  '';

  enableParallelBuilding = true;
}
