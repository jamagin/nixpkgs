{ stdenv, fetchsvn, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "spawn-fcgi-${version}";
  version = "1.6.4";

  src = fetchsvn {
    url = "svn://svn.lighttpd.net/spawn-fcgi/tags/spawn-fcgi-${version}";
    sha256 = "07r6nwbg4881mdgp0hqh80c4x9wb7jg6cgc84ghwhfbd2abc2iq5";
  };

  buildInputs = [ automake autoconf ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage    = "http://redmine.lighttpd.net/projects/spawn-fcgi";
    description = "Provides an interface to external programs that support the FastCGI interface";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ cstrahan ];
  };
}
