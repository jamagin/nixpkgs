{ stdenv, fetchurl, ... }:

let
  arch = {
    "x86_64-linux" = "x64";
    "i686-linux" = "i386";
  }.${stdenv.system};
  sha256s = {
    "x86_64-linux" = "15gji5zqs1py92bpwvvq0r1spl0yynbrsnh4ajphwq17bqys3192";
    "i686-linux"   = "1y67bd63b95va7g2676rgp2clvcy09pnmivy00r2w46y7kwwwbj8";
  };
  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.libc ];
in

stdenv.mkDerivation rec {
  name = "resilio-sync-${version}";
  version = "2.5.2";

  src = fetchurl {
    urls = [
      "https://download-cdn.resilio.com/${version}/linux-${arch}/resilio-sync_${arch}.tar.gz"
    ];
    sha256 = sha256s.${stdenv.system};
  };

  dontStrip = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot = ".";

  installPhase = ''
    install -D rslsync "$out/bin/rslsync"
    patchelf --interpreter "$(< $NIX_CC/nix-support/dynamic-linker)" --set-rpath ${libPath} "$out/bin/rslsync"
  '';

  meta = {
    description = "Automatically sync files via secure, distributed technology";
    homepage    = https://www.resilio.com/;
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ domenkozar thoughtpolice cwoac ];
  };
}
