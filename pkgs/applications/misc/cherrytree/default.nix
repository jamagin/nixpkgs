{ stdenv, fetchurl, python, pythonPackages, gettext, pygtksourceview, sqlite }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "cherrytree-${version}";
  version = "0.35.9";

  src = fetchurl {
    url = "http://www.giuspen.com/software/${name}.tar.xz";
    sha256 = "14yahp0y13z3xkpwvprm7q9x3rj6jbzi0bryqlsn3bbafdq7wnac";
  };

  propagatedBuildInputs = with pythonPackages;
  [ sqlite3 ];

  buildInputs = with pythonPackages;
  [ python gettext wrapPython pygtk dbus pygtksourceview ];

  pythonPath = with pythonPackages;
  [ pygtk dbus pygtksourceview ];

  patches = [ ./subprocess.patch ];

  installPhase = ''
    python setup.py install --prefix="$out"

    for file in "$out"/bin/*; do
        wrapProgram "$file" \
            --prefix PYTHONPATH : "$(toPythonPath $out):$PYTHONPATH"
    done
  '';

  doCheck = false;

  meta = { 
    description = "An hierarchical note taking application";
    longDescription = ''
      Cherrytree is an hierarchical note taking application,
      featuring rich text, syntax highlighting and powerful search
      capabilities. It organizes all information in units called
      "nodes", as in a tree, and can be very useful to store any piece
      of information, from tables and links to pictures and even entire
      documents. All those little bits of information you have scattered
      around your hard drive can be conveniently placed into a
      Cherrytree document where you can easily find it.
    ''; 
    homepage = http://www.giuspen.com/cherrytree;
    license = licenses.gpl3;
    platforms = platforms.linux; 
    maintainers = [ maintainers.AndersonTorres ]; 
  }; 
}
