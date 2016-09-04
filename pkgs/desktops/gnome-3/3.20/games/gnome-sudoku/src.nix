# Autogenerated by maintainers/scripts/gnome.sh update

fetchurl: rec {
  major = "3.20";
  name = "gnome-sudoku-${major}.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-sudoku/${major}/${name}.tar.xz";
    sha256 = "1hw6r0yfg60ynp4gxnqm6zrsklzn0d6lb88vybdbifzrlaww8xwh";
  };
}
