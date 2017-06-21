args @ { fetchurl, ... }:
rec {
  baseName = ''cl-vectors'';
  version = ''20170516-git'';

  description = ''cl-paths: vectorial paths manipulation'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-vectors/2017-05-16/cl-vectors-20170516-git.tgz'';
    sha256 = ''0j7cdg6akq5giv8rgbxdv8rwpzkv98r5bv78p5nnrixpprvjhvzx'';
  };
    
  packageName = "cl-vectors";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-vectors[.]asd${"$"}' |
        while read f; do
          env -i \
          NIX_LISP="$NIX_LISP" \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(progn
            (asdf:load-system :$(basename "$f" .asd))
            (asdf:perform (quote asdf:compile-bundle-op) :$(basename "$f" .asd))
            (ignore-errors (asdf:perform (quote asdf:deliver-asd-op) :$(basename "$f" .asd)))
            )'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cl-vectors DESCRIPTION cl-paths: vectorial paths manipulation SHA256 0j7cdg6akq5giv8rgbxdv8rwpzkv98r5bv78p5nnrixpprvjhvzx URL
    http://beta.quicklisp.org/archive/cl-vectors/2017-05-16/cl-vectors-20170516-git.tgz MD5 0258ae7face22f2035c1a85379ee0aae NAME cl-vectors TESTNAME NIL
    FILENAME cl-vectors DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS (cl-aa-misc cl-aa cl-paths-ttf cl-paths)) */
