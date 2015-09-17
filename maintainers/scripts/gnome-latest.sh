#!/usr/bin/env bash

GNOME_FTP="ftp.gnome.org/pub/GNOME/sources"

project=$1

if [ "$project" == "--help" ]; then
  echo "Usage: $0 project [major.minor]"
  exit 0
fi

majorVersion=$2

if [ -z "$project" ]; then
  echo "No project specified, exiting"
  exit 1
fi

# curl -l ftp://... doesn't work from my office in HSE, and I don't want to have
# any conversations with sysadmin. Somehow lftp works.
if [ "$FTP_CLIENT" = "lftp" ]; then
  ls_ftp() {
    lftp -c "open $1; cls"
  }
else
  ls_ftp() {
    curl -s -l "$1"/
  }
fi

if [ -z "$majorVersion" ]; then
  echo "Looking for available versions..." >&2
  available_baseversions=( `ls_ftp ftp://${GNOME_FTP}/${project} | grep '[0-9]\.[0-9]' | sort -t. -k1,1n -k 2,2n` )
  echo -e "The following versions are available:\n ${available_baseversions[@]}" >&2
  echo -en "Choose one of them: " >&2
  read majorVersion
fi

if echo "$majorVersion" | grep -q "[0-9]\+\.[0-9]\+\.[0-9]\+"; then
	# not a major version
	version="$majorVersion"
	majorVersion=$(echo "$majorVersion" | cut -d '.' -f 1,2)
fi

FTPDIR="${GNOME_FTP}/${project}/${majorVersion}"

#version=`curl -l ${FTPDIR}/ 2>/dev/null | grep LATEST-IS | sed -e s/LATEST-IS-//`
# gnome's LATEST-IS is broken. Do not trust it.

if [ -z "$version" ]; then
	files=$(ls_ftp "${FTPDIR}")
	declare -A versions
	
	for f in $files; do
		case $f in
    (LATEST-IS-*|*.news|*.changes|*.sha256sum|*.diff*):
		;;
    ($project-*.*.9*.tar.*):
		tmp=${f#$project-}
		tmp=${tmp%.tar*}
		echo "Ignored unstable version ${tmp}" >&2
		;;
    ($project-*.tar.*):
		tmp=${f#$project-}
		tmp=${tmp%.tar*}
		versions[${tmp}]=1
		;;
    (*):
		echo "UNKNOWN FILE $f"
		;;
		esac
	done
	echo "Found versions ${!versions[@]}" >&2
	version=`echo ${!versions[@]} | sed -e 's/ /\n/g' | sort -t. -k1,1n -k 2,2n -k 3,3n | tail -n1`
	echo "Latest version is: ${version}" >&2
fi

name=${project}-${version}
echo "Fetching .sha256 file" >&2
sha256out=$(curl -s -f http://${FTPDIR}/${name}.sha256sum)

if [ "$?" -ne "0" ]; then
	echo "Version not found" >&2
	exit 1
fi

extensions=( "xz" "bz2" "gz" )
echo "Choosing archive extension (known are ${extensions[@]})..." >&2
for ext in ${extensions[@]}; do
  if echo -e "$sha256out" | grep -q "\\.tar\\.${ext}$"; then
    ext_pref=$ext
    sha256=$(echo -e "$sha256out" | grep "\\.tar\\.${ext}$" | cut -f1 -d\ )
    break
  fi
done
sha256=`nix-hash --to-base32 --type sha256 $sha256`
echo "Chosen ${ext_pref}, hash is ${sha256}" >&2

cat <<EOF
{
  name = "${project}-${version}";

  src = fetchurl {
    url = mirror://gnome/sources/${project}/${majorVersion}/${project}-${version}.tar.${ext_pref};
    sha256 = "${sha256}";
  };
}
EOF
