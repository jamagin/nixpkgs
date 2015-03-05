{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.2.3";
  name = "numix-${version}";
  
  src = fetchurl {
    url = "https://github.com/shimmerproject/Numix/archive/v${version}.tar.gz";
    sha256 = "b0acc2d81300b898403766456d3406304553cc7016677381f3179dbeb1192a2d";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/usr/share/themes/Numix
    cp -dr --no-preserve='ownership' {LICENSE,CREDITS,index.theme,gtk-2.0,gtk-3.0,metacity-1,openbox-3,unity,xfce-notify-4.0,xfwm4} $out/usr/share/themes/Numix/
  '';
  
  meta = {
    description = "Numix GTK theme";
    homepage = https://numixproject.org;
    platforms = stdenv.lib.platforms.linux;
  };
}
