{ stdenv, fetchurl, perl, git }:

stdenv.mkDerivation rec {
  name = "gitolite-${version}";
  version = "3.6.1";

  src = fetchurl {
    url = "https://github.com/sitaramc/gitolite/archive/v${version}.tar.gz";
    sha256 = "0sizzv705aypasi9vf9kmdbzcl3gmyfxg9dwdl5prn64biqkvq3y";
  };

  buildInputs = [ perl git ];
  buildPhase = "true";

  patchPhase = ''
    substituteInPlace ./install --replace " 2>/dev/null" ""
    substituteInPlace src/lib/Gitolite/Hooks/PostUpdate.pm \
      --replace /usr/bin/perl "${perl}/bin/perl"
    substituteInPlace src/lib/Gitolite/Hooks/Update.pm \
      --replace /usr/bin/perl "${perl}/bin/perl"
  '';

  installPhase = ''
    mkdir -p $out/bin
    perl ./install -to $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Finely-grained git repository hosting";
    homepage    = http://gitolite.com/gitolite/index.html;
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
