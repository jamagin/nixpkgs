{ stdenv, fetchgit, go }:

stdenv.mkDerivation rec {
  name = "hub-${version}";
  version = "2.2.0-rc1";

  src = fetchgit {
    url = https://github.com/github/hub.git;
    rev = "refs/tags/v${version}";
    sha256 = "1f6r8vlwnmqmr85drfv24vhqx1aacz6s83c2i804v9997n0wrwfm";
  };


  buildInputs = [ go ];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    ./script/build
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp hub "$out/bin/"

    mkdir -p "$out/share/man/man1"
    cp "man/hub.1" "$out/share/man/man1/"

    mkdir -p "$out/share/zsh/site-functions"
    cp "etc/hub.zsh_completion" "$out/share/zsh/site-functions/_hub"

# Broken: https://github.com/github/hub/issues/592
#    mkdir -p "$out/etc/bash_completion.d"
#    cp "etc/hub.bash_completion.sh" "$out/etc/bash_completion.d/"

# Should we also install provided git-hooks?
# ?
  '';


  meta = with stdenv.lib; {
    description = "Command-line wrapper for git that makes you better at GitHub";

    license = licenses.mit;
    homepage = https://hub.github.com/;
    maintainers = with maintainers; [ the-kenny ];
  };
}
