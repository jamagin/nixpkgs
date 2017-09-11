{ stdenv, fetchgit, cmake, pkgconfig, qtbase, qtwebkit, qtkeychain, sqlite
, inotify-tools }:

stdenv.mkDerivation rec {
  name = "nextcloud-client-${version}";
  version = "2.3.2";

  src = fetchgit {
    url = "git://github.com/nextcloud/client_theming.git";
    rev = "1ee750d1aeaaefc899629e85c311594603e9ac1b";
    sha256 = "0dxyng8a7cg78z8yngiqypsb44lf5c6vkabvkfch0cl0cqmarc1a";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ qtbase qtwebkit qtkeychain sqlite ]
    ++ stdenv.lib.optional stdenv.isLinux inotify-tools;

  dontUseCmakeBuildDir = true;

  cmakeDir = "client";

  cmakeFlags = [
    "-UCMAKE_INSTALL_LIBDIR"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DOEM_THEME_DIR=${src}/nextcloudtheme"
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    "-DINOTIFY_LIBRARY=${inotify-tools}/lib/libinotifytools.so"
    "-DINOTIFY_INCLUDE_DIR=${inotify-tools}/include"
  ];

  meta = with stdenv.lib; {
    description = "Nextcloud themed desktop client";
    homepage = https://nextcloud.com;
    license = licenses.gpl2;
    maintainers = with maintainers; [ caugner ];
    platforms = platforms.unix;
  };
}
