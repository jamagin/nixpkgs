{ kde, kdelibs, gcc }:

kde {
  buildInputs = [ kdelibs ];

  preConfigure = "export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:${gcc}:${gcc.gcc}";

  meta = {
    description = "various KDE development utilities";
  };
}
