{ stdenv, fetchFromGitLab, git, go }:

stdenv.mkDerivation rec {
  version = "2.2.0";
  name = "gitlab-workhorse-${version}";

  srcs = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "18cf34b8651ilxfgzmxlcd9cw7b7kgndfw9k83f6fwm8j7mdisn9";
  };

  buildInputs = [ git go ];

  patches = [ ./remove-hardcoded-paths.patch ];

  buildPhase = ''
    make PREFIX=$out
  '';

  installPhase = ''
    mkdir -p $out/bin
    make install PREFIX=$out
  '';

  meta = with stdenv.lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.mit;
  };
}
