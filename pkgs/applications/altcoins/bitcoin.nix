{ stdenv, fetchurl, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qt4, utillinux, protobuf, qrencode
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-" + version;
  core_version = "0.10.2";
  version = core_version;

  src = fetchurl {
    url = [ "https://bitcoin.org/bin/bitcoin-core-${core_version}/bitcoin-${version}.tar.gz"
            "mirror://sourceforge/bitcoin/Bitcoin/bitcoin-${core_version}/bitcoin-${version}.tar.gz"
          ];
    sha256 = "cddf96c71d0a35524fde93380981cf0cf0b51441454a3a68b9be491b9239bfec";
  };

  buildInputs = [ pkgconfig autoreconfHook openssl db48 boost zlib
                  miniupnpc utillinux protobuf ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.lib}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt4" ];

  meta = {
    description = "Peer-to-peer electronic cash system";
    longDescription= ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = "http://www.bitcoin.org/";
    maintainers = with maintainers; [ roconnor AndersonTorres ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
