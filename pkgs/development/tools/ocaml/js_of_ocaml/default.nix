{stdenv, fetchurl, ocaml, findlib, ocaml_lwt, menhir, ocsigen_deriving, camlp4,
 cmdliner}:

stdenv.mkDerivation {
  name = "js_of_ocaml";
  src = fetchurl {
    url = https://github.com/ocsigen/js_of_ocaml/archive/2.5.tar.gz;
    sha256 = "1prm08nf8szmd3p13ysb0yx1cy6lr671bnwsp25iny8hfbs39sjv";
    };
  
  buildInputs = [ocaml findlib ocaml_lwt menhir ocsigen_deriving
                 cmdliner camlp4];

  patches = [ ./Makefile.conf.diff ];  

  createFindlibDestdir = true;


  meta =  {
    homepage = http://ocsigen.org/js_of_ocaml/;
    description = "Compiler of OCaml bytecode to Javascript. It makes it possible to run Ocaml programs in a Web browser";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };


}
