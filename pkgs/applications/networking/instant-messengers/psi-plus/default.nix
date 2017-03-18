{ stdenv, fetchFromGitHub
, which, pkgconfig
, qt4, libidn, qca2, libXScrnSaver, enchant
}:

stdenv.mkDerivation rec {
  name = "psi-plus-${version}";
  version = "0.16.575.639";

  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = "${version}";
    sha256 = "0mn24y3y4qybw81rjy0hr46y7y96dvwdl6kk61kizwj32z1in8cg";
  };

  resources = fetchFromGitHub {
    owner = "psi-plus";
    repo = "resources";
    rev = "8f5038380e1be884b04b5a1ad3cc3385e793f668";
    sha256 = "1b8a2aixg966fzjwp9hz51rc31imyvpx014mp2fsm47k8na4470d";
  };

  postUnpack = ''
    cp -a "${resources}/iconsets" "$sourceRoot"
  '';

  nativeBuildInputs = [ which pkgconfig ];

  buildInputs = [ qt4 libidn qca2 libXScrnSaver enchant ];

  NIX_CFLAGS_COMPILE="-I${qca2}/include/QtCrypto";

  NIX_LDFLAGS="-lqca";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "XMPP (Jabber) client";
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
