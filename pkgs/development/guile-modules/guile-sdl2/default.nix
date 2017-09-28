{ stdenv, fetchgit, autoconf, automake, guile, libtool, pkgconfig
, SDL2, SDL2_image, SDL2_ttf, SDL2_mixer
}:

let
  name = "${pname}-${version}";
  pname = "guile-sdl2";
  version = "0.1.0";
in stdenv.mkDerivation {
  inherit name;

  src = fetchgit {
    url = "git://dthompson.us/guile-sdl2.git";
    rev = "048f80ddb5c6b03b87bba199a99a6f22d911bfff";
    sha256 = "1v7bc2bsddb46qdzq7cyzlw5i2y175kh66mbzbjky85sjfypb084";
  };

  buildInputs = [
    autoconf automake guile libtool pkgconfig
    SDL2 SDL2_image SDL2_ttf SDL2_mixer
  ];

  preConfigurePhases = [ "bootstrapPhase" ];

  bootstrapPhase = "./bootstrap";

  configureFlags = [
    "--with-libsdl2-prefix=${SDL2}"
    "--with-libsdl2-image-prefix=${SDL2_image}"
    "--with-libsdl2-ttf-prefix=${SDL2_ttf}"
    "--with-libsdl2-mixer-prefix=${SDL2_mixer}"
  ];

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  meta = with stdenv.lib; {
    description = "Bindings to SDL2 for GNU Guile";
    homepage = "https://dthompson.us/projects/guile-sdl2.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seppeljordan vyp ];
    platforms = platforms.all;
  };
}
