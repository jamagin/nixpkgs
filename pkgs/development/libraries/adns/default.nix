{ stdenv, fetchurl }:

let
  version = "1.5.0";
in
stdenv.mkDerivation {
  name = "adns-${version}";

  src = fetchurl {
    urls = [
      "http://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-${version}.tar.gz"
      "ftp://ftp.chiark.greenend.org.uk/users/ian/adns/adns-${version}.tar.gz"
      "mirror://gnu/adns/adns-${version}.tar.gz"
    ];
    sha256 = "0hg89b5n84zjhzvbzrpvhl0hbm4s6d1z2pzllfis64ai656ypibz";
  };

  preConfigure =
    stdenv.lib.optionalString stdenv.isDarwin "sed -i -e 's|-Wl,-soname=$(SHLIBSONAME)||' configure";

  # http://thread.gmane.org/gmane.linux.distributions.nixos/1328 for details.
  doCheck = false;

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/libadns.so.1.3 $out/lib/libadns.so.1.3
  '';

  meta = {
    homepage = "http://www.chiark.greenend.org.uk/~ian/adns/";
    description = "Asynchronous DNS Resolver Library";
    license = stdenv.lib.licenses.lgpl2;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
