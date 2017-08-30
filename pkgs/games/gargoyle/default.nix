{ stdenv, fetchFromGitHub, jam, libtool, pkgconfig, gtk2, SDL, SDL_mixer, SDL_sound, smpeg, libvorbis }:

let

  jamenv = ''
    unset AR
  '' + (if stdenv.isDarwin then ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${SDL.dev}/include/SDL"
    export GARGLKINI="$out/Applications/Gargoyle.app/Contents/Resources/garglk.ini"
  '' else ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/libexec/gargoyle"
    export DESTDIR="$out"
    export _BINDIR=libexec/gargoyle
    export _APPDIR=libexec/gargoyle
    export _LIBDIR=libexec/gargoyle
    export GARGLKINI="$out/etc/garglk.ini"
  '');

in

stdenv.mkDerivation {
  name = "gargoyle-2017-08-27";

  src = fetchFromGitHub {
    owner = "garglk";
    repo = "garglk";
    rev = "65c95166f53adaa2e5e1a5e0d8a34e9219d06de6";
    sha256 = "1agnap38qdf2n1v37ka3ky44j56yhvln4lzf13diyqhjmh9lvfq5";
  };

  nativeBuildInputs = [ jam pkgconfig ] ++ stdenv.lib.optional stdenv.isDarwin libtool;

  buildInputs = [ gtk2 SDL SDL_mixer ] ++ (
    if stdenv.isDarwin then [ smpeg libvorbis ] else [ SDL_sound ]
  );

  patches = [ ./darwin.patch ];

  buildPhase = jamenv + "jam -j$NIX_BUILD_CORES";

  installPhase = if stdenv.isDarwin then (builtins.readFile ./darwin.sh) else jamenv + ''
    jam -j$NIX_BUILD_CORES install
    mkdir -p "$out/bin"
    ln -s ../libexec/gargoyle/gargoyle "$out/bin"
    mkdir -p "$out/etc"
    cp garglk/garglk.ini "$out/etc"
    mkdir -p "$out/share/applications"
    cp garglk/gargoyle.desktop "$out/share/applications"
    mkdir -p "$out/share/icons/hicolor/32x32/apps"
    cp garglk/gargoyle-house.png "$out/share/icons/hicolor/32x32/apps"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://ccxvii.net/gargoyle/;
    license = licenses.gpl2Plus;
    description = "Interactive fiction interpreter GUI";
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
