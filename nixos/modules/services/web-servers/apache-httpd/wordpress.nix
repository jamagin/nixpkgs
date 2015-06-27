{ config, lib, pkgs, serverInfo, php, ... }:
# http://codex.wordpress.org/Hardening_WordPress

with lib;

let

  version = "4.2";
  fullversion = "${version}.2";

  # Our bare-bones wp-config.php file using the above settings
  wordpressConfig = pkgs.writeText "wp-config.php" ''
    <?php
    define('DB_NAME',     '${config.dbName}');
    define('DB_USER',     '${config.dbUser}');
    define('DB_PASSWORD', '${config.dbPassword}');
    define('DB_HOST',     '${config.dbHost}');
    define('DB_CHARSET',  'utf8');
    $table_prefix  = '${config.tablePrefix}';
    if ( !defined('ABSPATH') )
    	define('ABSPATH', dirname(__FILE__) . '/');
    require_once(ABSPATH . 'wp-settings.php');
    ${config.extraConfig}
  '';

  # .htaccess to support pretty URLs
  htaccess = pkgs.writeText "htaccess" ''
    <IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    RewriteRule ^index\.php$ - [L]

    # add a trailing slash to /wp-admin
    RewriteRule ^wp-admin$ wp-admin/ [R=301,L]

    RewriteCond %{REQUEST_FILENAME} -f [OR]
    RewriteCond %{REQUEST_FILENAME} -d
    RewriteRule ^ - [L]
    RewriteRule ^(wp-(content|admin|includes).*) $1 [L]
    RewriteRule ^(.*\.php)$ $1 [L]
    RewriteRule . index.php [L]
    </IfModule>
  '';

  # WP translation can be found here:
  #   https://make.wordpress.org/polyglots/teams/
  # FIXME: 
  #  - add all these languages: 
  #    sq ar az eu bs bg ca zh-cn zh-tw hr da nl en-au 
  #    en-ca en-gb eo fi fr gl de el he hu is id it ja 
  #    ko lt nb nn oci pl pt-br pt ro ru sr sk es-mx es 
  #    sv th tr uk cy
  #  - cache the files on github.com/qknight/WordpressLanguages and use fetchFromGithub instead
  #    note: this implementation of supportedLanguages will only work for me (qknight) as i'm using nix-prefetch-url
  #          as the sha256 changes like every download. 
  # note: this is also true for plugins and themes but these are controlled not from withing wordpress.nix
  supportedLanguages = {
    en_GB = "1yf1sb6ji3l4lg8nkkjhckbwl81jly8z93jf06pvk6a1p6bsr6l6";
    de_DE = "3881221f337799b88f9562df8b3f1560f2c49a8f662297561a5b25ce77f22e17";
  };

  downloadLanguagePack = language: sha256:
    pkgs.stdenv.mkDerivation rec {
      name = "wp_${language}-${version}";
      src = pkgs.fetchurl {
        url = "https://downloads.wordpress.org/translation/core/${version}/${language}.zip";
        sha256 = "${sha256}";
      };
      buildInputs = [ pkgs.unzip ];
      unpackPhase = ''
        unzip $src
        export sourceRoot=.
      '';
      installPhase = "mkdir -p $out; cp -R * $out/";
    };

  selectedLanguages = map (lang: downloadLanguagePack lang supportedLanguages.${lang}) (config.languages);

  # The wordpress package itself
  wordpressRoot = pkgs.stdenv.mkDerivation rec {
    name = "wordpress";
    src = pkgs.fetchFromGitHub {
      owner = "WordPress";
      repo = "WordPress";
      rev = "${fullversion}";
      sha256 = "0gq1j9b0d0rykql3jzdb2yn4adj0rrcsvqrmj3dzx11ir57ilsgc";
    };
    installPhase = ''
      mkdir -p $out
      # copy all the wordpress files we downloaded
      cp -R * $out/

      # symlink the wordpress config
      ln -s ${wordpressConfig} $out/wp-config.php
      # symlink custom .htaccess
      ln -s ${htaccess} $out/.htaccess
      # symlink uploads directory
      ln -s ${config.wordpressUploads} $out/wp-content/uploads

      # remove bundled plugins(s) coming with wordpress
      rm -Rf $out/wp-content/plugins/*
      # remove bundled themes(s) coming with wordpress
      rm -Rf $out/wp-content/themes/*

      # symlink additional theme(s)
      ${concatMapStrings (theme: "ln -s ${theme} $out/wp-content/themes/${theme.name}\n") config.themes}
      # symlink additional plugin(s)
      ${concatMapStrings (plugin: "ln -s ${plugin} $out/wp-content/plugins/${plugin.name}\n") (config.plugins) }

      # symlink additional translation(s) 
      mkdir -p $out/wp-content/languages
      ${concatMapStrings (language: "ln -s ${language}/*.mo ${language}/*.po $out/wp-content/languages/\n") (selectedLanguages) }
    '';
  };

in

{

  # And some httpd extraConfig to make things work nicely
  extraConfig = ''
    <Directory ${wordpressRoot}>
      DirectoryIndex index.php
      Allow from *
      Options FollowSymLinks
      AllowOverride All
    </Directory>
  '';

  enablePHP = true;

  options = {
    dbHost = mkOption {
      default = "localhost";
      description = "The location of the database server.";  
      example = "localhost";
    };
    dbName = mkOption {
      default = "wordpress";
      description = "Name of the database that holds the Wordpress data.";
      example = "localhost";
    };
    dbUser = mkOption {
      default = "wordpress";
      description = "The dbUser, read: the username, for the database.";
      example = "wordpress";
    };
    dbPassword = mkOption {
      default = "wordpress";
      description = "The mysql password to the respective dbUser.";
      example = "wordpress";
    };
    tablePrefix = mkOption {
      default = "wp_";
      description = ''
        The $table_prefix is the value placed in the front of your database tables. Change the value if you want to use something other than wp_ for your database prefix. Typically this is changed if you are installing multiple WordPress blogs in the same database. See <link xlink:href='http://codex.wordpress.org/Editing_wp-config.php#table_prefix'/>.
      '';
    };
    wordpressUploads = mkOption {
    default = "/data/uploads";
      description = ''
        This directory is used for uploads of pictures and must be accessible (read: owned) by the httpd running user. The directory passed here is automatically created and permissions are given to the httpd running user.
      '';
    };
    plugins = mkOption {
      default = [];
      type = types.listOf types.path;
      description =
        ''
          List of path(s) to respective plugin(s) which are symlinked from the 'plugins' directory. Note: These plugins need to be packaged before use, see example.
        '';
      example = ''
        # Wordpress plugin 'akismet' installation example
        akismetPlugin = pkgs.stdenv.mkDerivation {
          name = "akismet-plugin";
          # Download the theme from the wordpress site
          src = pkgs.fetchurl {
            url = https://downloads.wordpress.org/plugin/akismet.3.1.zip;
            sha256 = "1i4k7qyzna08822ncaz5l00wwxkwcdg4j9h3z2g0ay23q640pclg";
          };
          # We need unzip to build this package
          buildInputs = [ pkgs.unzip ];
          # Installing simply means copying all files to the output directory
          installPhase = "mkdir -p $out; cp -R * $out/";
        };

        And then pass this theme to the themes list like this:
          plugins = [ akismetPlugin ];
      '';
    };
    themes = mkOption {
      default = [];
      type = types.listOf types.path;
      description =
        ''
          List of path(s) to respective theme(s) which are symlinked from the 'theme' directory. Note: These themes need to be packaged before use, see example.
        '';
      example = ''
        # For shits and giggles, let's package the responsive theme
        responsiveTheme = pkgs.stdenv.mkDerivation {
          name = "responsive-theme";
          # Download the theme from the wordpress site
          src = pkgs.fetchurl {
            url = http://wordpress.org/themes/download/responsive.1.9.7.6.zip;
            sha256 = "06i26xlc5kdnx903b1gfvnysx49fb4kh4pixn89qii3a30fgd8r8";
          };
          # We need unzip to build this package
          buildInputs = [ pkgs.unzip ];
          # Installing simply means copying all files to the output directory
          installPhase = "mkdir -p $out; cp -R * $out/";
        };

        And then pass this theme to the themes list like this:
          themes = [ responsiveTheme ];
      '';
    };
    languages = mkOption {
          default = [];
          description = "Installs wordpress language packs based on the list, see wordpress.nix for possible translations.";
          example = "[ \"en_GB\" \"de_DE\" ];";
    };
    extraConfig = mkOption {
      default = "";
      example =
        ''
          define( 'AUTOSAVE_INTERVAL', 60 ); // Seconds
        '';
      description = ''
        Any additional text to be appended to Wordpress's wp-config.php
        configuration file.  This is a PHP script.  For configuration
        settings, see <link xlink:href='http://codex.wordpress.org/Editing_wp-config.php'/>.
      '';
    };
  }; 

  documentRoot = wordpressRoot;

  startupScript = pkgs.writeScript "init-wordpress.sh" ''
    #!/bin/sh
    mkdir -p ${config.wordpressUploads}
    chown ${serverInfo.serverConfig.user} ${config.wordpressUploads}

    # we should use systemd dependencies here
    #waitForUnit("network-interfaces.target");
    if [ ! -d ${serverInfo.fullConfig.services.mysql.dataDir}/${config.dbName} ]; then
      echo "Need to create the database '${config.dbName}' and grant permissions to user named '${config.dbUser}'."
      # Wait until MySQL is up
      while [ ! -e /var/run/mysql/mysqld.pid ]; do
        sleep 1
      done
      ${pkgs.mysql}/bin/mysql -e 'CREATE DATABASE ${config.dbName};'
      ${pkgs.mysql}/bin/mysql -e 'GRANT ALL ON ${config.dbName}.* TO ${config.dbUser}@localhost IDENTIFIED BY "${config.dbPassword}";'
    else 
      echo "Good, no need to do anything database related."
    fi
  '';
}
