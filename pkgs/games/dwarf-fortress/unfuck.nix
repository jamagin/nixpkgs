{ stdenv, fetchgit, cmake
, mesa, SDL, SDL_image, SDL_ttf, glew, openalSoft
, ncurses, glib, gtk2, libsndfile
}:

stdenv.mkDerivation {
  name = "dwarf_fortress_unfuck-20160118";

  src = fetchgit {
    url = "https://github.com/svenstaro/dwarf_fortress_unfuck";
    rev = "9a796c6d3cd7d41784e9d1d22a837a1ee0ff8553";
    sha256 = "0ibxdn684zpk3v2gigardq6z9mydc2s9hns8hlxjyyyhnk1ar61g";
  };

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2}/lib/gtk-2.0/include"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    mesa SDL SDL_image SDL_ttf glew openalSoft
    ncurses gtk2 libsndfile
  ];

  installPhase = ''
    install -D -m755 ../build/libgraphics.so $out/lib/libgraphics.so
  '';

  enableParallelBuilding = true;

  passthru.dfVersion = "0.42.05";

  meta = with stdenv.lib; {
    description = "Unfucked multimedia layer for Dwarf Fortress";
    homepage = https://github.com/svenstaro/dwarf_fortress_unfuck;
    license = licenses.free;
    platforms = [ "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
