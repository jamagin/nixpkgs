{ stdenv, fetchurl, pkgconfig, zlib, ncurses ? null, perl ? null, pam }:

stdenv.mkDerivation rec {
  name = "util-linux-2.26.1";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v2.26/${name}.tar.xz";
    sha256 = "0vmvk5khfwf71xbsnplvmk9ikwnlbhysc96mnkgwpqk2faairp12";
  };

  patches = [ ./rtcwake-search-PATH-for-shutdown.patch
            ];

  outputs = [ "bin" "out" "man" ]; # TODO: $bin is kept the first for now
  # due to lots of ${utillinux}/bin occurences and headers being rather small
  outputDev = "bin";


  #FIXME: make it also work on non-nixos?
  postPatch = ''
    # Substituting store paths would create a circular dependency on systemd
    substituteInPlace include/pathnames.h \
      --replace "/bin/login" "/run/current-system/sw/bin/login" \
      --replace "/sbin/shutdown" "/run/current-system/sw/bin/shutdown"
  '';

  crossAttrs = {
    # Work around use of `AC_RUN_IFELSE'.
    preConfigure = "export scanf_cv_type_modifier=ms";
  };

  # !!! It would be better to obtain the path to the mount helpers
  # (/sbin/mount.*) through an environment variable, but that's
  # somewhat risky because we have to consider that mount can setuid
  # root...
  configureFlags = ''
    --enable-write
    --enable-last
    --enable-mesg
    --disable-use-tty-group
    --enable-fs-paths-default=/var/setuid-wrappers:/var/run/current-system/sw/bin:/sbin
    ${if ncurses == null then "--without-ncurses" else ""}
  '';

  makeFlags = "usrbin_execdir=$(bin)/bin usrsbin_execdir=$(bin)/sbin";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs =
    [ zlib pam ]
    ++ stdenv.lib.optional (ncurses != null) ncurses
    ++ stdenv.lib.optional (perl != null) perl;

  postInstall = ''
    rm "$bin/bin/su" # su should be supplied by the su package (shadow)
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.kernel.org/pub/linux/utils/util-linux/;
    description = "A set of system utilities for Linux";
    license = licenses.gpl2; # also contains parts under more permissive licenses
    platforms = platforms.linux;
  };
}
