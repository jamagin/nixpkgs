{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libargon2-${version}";
  version = "20161029";
  src = fetchFromGitHub {
    owner = "P-H-C";
    repo = "phc-winner-argon2";
    rev = "${version}";
    sha256 = "021g8wi4g67ywm8zf3yncqwrmfz7ypgm1ih9wcmnxip5n75rymh5";
  };

  installPhase = ''
    mkdir -p $out
    make install PREFIX=$out
    mkdir -p $out/lib/pkgconfig
    substitute libargon2.pc $out/lib/pkgconfig/libargon2.pc \
      --replace @UPSTREAM_VER@ "${version}"                 \
      --replace @HOST_MULTIARCH@ ""                         \
      --replace 'prefix=/usr' "prefix=$out"
    ln -s $out/lib/libargon2.so $out/lib/libargon2.so.0
  '';

  meta = with stdenv.lib; {
    description = "A key derivation function that was selected as the winner of the Password Hashing Competition in July 2015";
    longDescription = ''
      A password-hashing function created by by Alex Biryukov, Daniel Dinu, and
      Dmitry Khovratovich. Argon2 was declared the winner of the Password
      Hashing Competition (PHC). There were 24 submissions and 9 finalists.
      Catena, Lyra2, Makwa and yescrypt were given special recognition. The PHC
      recommends using Argon2 rather than legacy algorithms.
    '';
    homepage = https://www.argon2.com/;
    license = with licenses; [ asl20 cc0 ];
    maintainers = with maintainers; [ taeer olynch ];
    platforms = platforms.linux;
  };
}
