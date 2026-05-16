#!/bin/bash

# Make Deb Package for NullPhish (^.^)
_PACKAGE=NullPhish
_VERSION=1.0
_ARCH="all"
PKG_NAME="${_PACKAGE}_${_VERSION}_${_ARCH}.deb"

if [[ ! -e "scripts/launch.sh" ]]; then
        echo "launch.sh should be in the \`scripts\` Directory. Exiting..."
        exit 1
fi

if [[ ${1,,} == "termux" || $(uname -o) == *'Android'* ]];then
        _depend="ncurses-utils, proot, resolv-conf, "
        _bin_dir="data/data/com.termux/files/"
        _opt_dir="data/data/com.termux/files/usr/"
        #PKG_NAME=${_PACKAGE}_${_VERSION}_${_ARCH}_termux.deb
fi

_depend+="curl, php, unzip"
_bin_dir+="usr/bin"
_opt_dir+="opt/${_PACKAGE}"

if [[ -d "build_env" ]]; then rm -fr build_env; fi
mkdir -p build_env
mkdir -p ./build_env/${_bin_dir} ./build_env/$_opt_dir ./build_env/DEBIAN 

cat <<- CONTROL_EOF > ./build_env/DEBIAN/control
Package: ${_PACKAGE}
Version: ${_VERSION}
Architecture: ${_ARCH}
Maintainer: @r4tur1
Depends: ${_depend}
Homepage: https://github.com/r4tur1/NullPhish
Description: An automated phishing tool with 30+ templates (Updated version of zphisher) . This Tool is made for educational purpose only ! Author will not be responsible for any misuse of this toolkit !
Resources

CONTROL_EOF

cat <<- PRERM_EOF > ./build_env/DEBIAN/prerm
#!/bin/bash
rm -fr $_opt_dir
exit 0
PRERM_EOF

chmod 755 ./build_env/DEBIAN
chmod 755 ./build_env/DEBIAN/{control,prerm}
cp -fr scripts/launch.sh ./build_env/$_bin_dir/$_PACKAGE
chmod 755 ./build_env/$_bin_dir/$_PACKAGE
cp -fr .github/ .sites/ LICENSE README.md nullphish.sh ./build_env/$_opt_dir
dpkg-deb --build ./build_env ${PKG_NAME}
rm -fr ./build_env
