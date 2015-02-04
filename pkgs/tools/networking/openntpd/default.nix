{ stdenv, fetchurl, openssl
, privsepPath ? "/var/empty"
, privsepUser ? "ntp"
}:

stdenv.mkDerivation rec {
  name = "openntpd-${version}";
  version = "5.7p3";

  src = fetchurl {
    url = "git://git.debian.org/collab-maint/openntpd.git";
    sha256 = "4f417c8a4c21ed7ec3811107829f931404f9bf121855b8571a2ca3355695343a";
  };

  postPatch = ''
    sed -i -e '/^install:/,/^$/{/@if.*PRIVSEP_PATH/,/^$/d}' Makefile.in
  '';

  configureFlags = [
    "--with-privsep-path=${privsepPath}"
    "--with-privsep-user=${privsepUser}"
  ];

  buildInputs = [ openssl ];

  meta = with stdenv.lib; {
    homepage = "http://www.openntpd.org/";
    license = licenses.bsd3;
    description = "OpenBSD NTP daemon (Debian port)";
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
