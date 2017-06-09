{ stdenv, fetchurl, SDL, SDL_mixer, zlib, libpng, gcc }:

stdenv.mkDerivation rec {
  name = "lbreakout2-${version}";
  version = "2.6.5";
  buildInputs = [ SDL SDL_mixer zlib libpng gcc ];

  src = fetchurl {
    url = "http://downloads.sourceforge.net/lgames/${name}.tar.gz";
    sha256 = "0vwdlyvh7c4y80q5vp7fyfpzbqk9lq3w8pvavi139njkalbxc14i";
  };

  meta = with stdenv.lib; {
    description = "Breakout clone from the LGames series";
    homepage = http://lgames.sourceforge.net/LBreakout2/;
    license = licenses.gpl;
    maintainers = [ maintainers.ciil ];
    platforms = platforms.linux;
  };
}

