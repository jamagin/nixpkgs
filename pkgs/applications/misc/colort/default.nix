{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "colort-unstable-2017-03-12";

  src = fetchFromGitHub {
    owner = "neeasade";
    repo = "colort";
    rev = "8470190706f358dc807b4c26ec3453db7f0306b6";
    sha256 = "10n8rbr2h6hz86hcx73f86pjbbfiaw2rvxsk0yfajnma7bpxgdxw";
  };

 installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    description = "A program for 'tinting' color values";
    homepage = https://github.com/neeasade/colort;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
