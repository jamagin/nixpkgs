{ stdenv, fetchurl, python, pygtk, makeWrapper }:

stdenv.mkDerivation rec {
  version = "0.4.7";
  name = "diffuse-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/diffuse/diffuse/${version}/${name}.tar.bz2";
    sha256 = "1b1riy9wix2gby78v9i30ijycjhkcyqsllggjakbkx26sb5nmxdh";
  };

  buildInputs = [ python pygtk makeWrapper ];

  buildPhase = ''
    python ./install.py --prefix="$out" --sysconfdir="$out/etc" --pythonbin="${python}/bin/python"
    wrapProgram "$out/bin/diffuse" --prefix PYTHONPATH : $PYTHONPATH:${pygtk}/lib/${python.libPrefix}/site-packages/gtk-2.0
  '';

  # no-op, everything is done in buildPhase
  installPhase = "true";

  # NOTE: diffuse installs a .desktop file itself

  meta = with stdenv.lib; {
    description = "Graphical diff and merge tool";
    homepage = http://diffuse.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
