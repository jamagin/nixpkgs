args @ { fetchurl, ... }:
rec {
  baseName = ''cl-cli'';
  version = ''20151218-git'';

  description = ''Command line parser'';

  deps = [ args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-cli/2015-12-18/cl-cli-20151218-git.tgz'';
    sha256 = ''0d097wjprljghkai1yacvjqmjm1mwpa46yxbacjnwps8pqwh18ay'';
  };
    
  packageName = "cl-cli";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-cli[.]asd${"$"}' |
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
/* (SYSTEM cl-cli DESCRIPTION Command line parser SHA256 0d097wjprljghkai1yacvjqmjm1mwpa46yxbacjnwps8pqwh18ay URL
    http://beta.quicklisp.org/archive/cl-cli/2015-12-18/cl-cli-20151218-git.tgz MD5 820e5c7dde6800fcfa44b1fbc7a9d62b NAME cl-cli TESTNAME NIL FILENAME cl-cli
    DEPS ((NAME split-sequence FILENAME split-sequence)) DEPENDENCIES (split-sequence) VERSION 20151218-git SIBLINGS NIL) */
