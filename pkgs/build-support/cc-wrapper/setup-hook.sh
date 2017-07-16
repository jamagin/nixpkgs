addCVars () {
    if [ -d $1/include ]; then
        export NIX_CFLAGS_COMPILE+=" ${ccIncludeFlag:--isystem} $1/include"
    fi

    if [ -d $1/lib64 -a ! -L $1/lib64 ]; then
        export NIX_LDFLAGS+=" -L$1/lib64"
    fi

    if [ -d $1/lib ]; then
        export NIX_LDFLAGS+=" -L$1/lib"
    fi

    if test -d $1/Library/Frameworks; then
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -F$1/Library/Frameworks"
    fi
}

envHooks+=(addCVars)

# Note: these come *after* $out in the PATH (see setup.sh).

if [ -n "@cc@" ]; then
    addToSearchPath _PATH @cc@/bin
fi

if [ -n "@binutils_bin@" ]; then
    addToSearchPath _PATH @binutils_bin@/bin
fi

if [ -n "@libc_bin@" ]; then
    addToSearchPath _PATH @libc_bin@/bin
fi

if [ -n "@coreutils_bin@" ]; then
    addToSearchPath _PATH @coreutils_bin@/bin
fi

if [ -z "$crossConfig" ]; then
  ENV_PREFIX=""
else
  ENV_PREFIX="BUILD_"
fi

export NIX_${ENV_PREFIX}CC=@out@

export ${ENV_PREFIX}CC=@named_cc@
export ${ENV_PREFIX}CXX=@named_cxx@

for CMD in \
    cpp \
    ar as nm objcopy ranlib strip strings size ld windres
do
    if
        PATH=$_PATH type -p "@binPrefix@$CMD" > /dev/null
    then
        export "${ENV_PREFIX}${CMD^^}=@binPrefix@${CMD}";
    fi
done

# No local scope available for sourced files
unset ENV_PREFIX
