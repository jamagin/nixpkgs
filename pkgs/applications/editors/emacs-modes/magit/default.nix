{ stdenv, fetchurl, emacs, texinfo, unzip }:

let
  version = "1.2.0";
in
stdenv.mkDerivation {
  name = "magit-${version}";

  src = fetchurl {
    url = "https://github.com/magit/magit/zipball/${version}";
    sha256 = "1877s8ikvcb457mmljmw366h6pgg4zzx98qfazhqj8snl4yqsj4i";
    name = "magit-${version}.zip";
  };

  buildInputs = [ emacs texinfo unzip ];

  configurePhase = "makeFlagsArray=( PREFIX=$out SYSCONFDIR=$out/etc )";

  # Add (require 'magit-site-init) to your ~/.emacs file to set-up magit mode.
  postInstall = ''
    mv $out/etc/emacs/site-start.d/50magit.el $out/share/emacs/site-lisp/magit-site-init.el
    sed -i -e 's|50magit|magit-site-init|' $out/share/emacs/site-lisp/magit-site-init.el
    rmdir $out/etc/emacs/site-start.d $out/etc/emacs $out/etc
  '';

  meta = {
    homepage = "https://github.com/magit/magit";
    description = "Magit, an Emacs interface to Git";
    license = "GPLv3+";

    longDescription = ''
      With Magit, you can inspect and modify your Git repositories with
      Emacs. You can review and commit the changes you have made to the
      tracked files, for example, and you can browse the history of past
      changes. There is support for cherry picking, reverting, merging,
      rebasing, and other common Git operations.

      Magit is not a complete interface to Git; it just aims to make the
      most common Git operations convenient. Thus, Magit will likely not
      save you from learning Git itself.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ simons ludo ];
  };
}
