#!/usr/bin/env bash

# Isar libraries are available as GitHub release artifacts.
# This script downloads the current version of the library and extracts/installs it locally.
# The download happens in a "download" directory.
# After download and extraction, the script asks if the lib should be installed in /usr/local/lib.
#
# Windows note: to run this script you need to install a bash like "Git Bash".
# Plain MINGW64, Cygwin, etc. might work too, but was not tested.

set -eu

#default values
quiet=false
printHelp=false
libBuildDir="$(pwd)/lib"
###

while :; do
    case ${1:-} in
        -h|--help)
          printHelp=true
        ;;
        --quiet)
          quiet=true
        ;;
        --install)
          quiet=true
          installLibrary=true
        ;;
        --uninstall)
          uninstallLibrary=true
        ;;
        *) break
    esac
    shift
done

tty -s || quiet=true

# Note: optional arguments like "--quiet" shifts argument positions in the case block above

version=${1:-2.5.14}
os=${2:-$(uname)}
arch=${3:-$(uname -m)}
echo "Base config: OS ${os} and architecture ${arch}"

if [[ "$os" == MINGW* ]] || [[ "$os" == CYGWIN* ]]; then
    os=Windows
    echo "Adjusted OS to $os"
elif [[ "$os" == "Darwin" ]]; then
    os=MacOS
    arch=universal
    echo "Adjusted OS to $os and architecture to $arch"
fi

if [[ $arch == "x86_64" ]]; then
    arch=x64
elif [[ $arch == armv7* ]]; then
    arch=armv7hf
    echo "Selected ${arch} architecture for download (hard FP only!)"
elif [[ $arch == armv6* ]]; then
    arch=armv6hf
    echo "Selected ${arch} architecture for download (hard FP only!)"
fi

# sudo might not be defined (e.g. when building a docker image)
sudo="sudo"
if [ ! -x "$(command -v sudo)" ]; then
    sudo=""
fi

# original location where we installed in previous versions of this script
oldLibDir=

if [[ "$os" = "MacOS" ]]; then
    libFileName=libisar.dylib
    libDirectory=/usr/local/lib
elif [[ "$os" = "Windows" ]]; then
    libFileName=isar_windows_x64.dll

    # this doesn't work in Git Bash, fails silently
    # sudo="runas.exe /user:administrator"
    # libDirectory=/c/Windows/System32

    # try to determine library path based on gcc.exe path
    libDirectory=""
    if [ -x "$(command -v gcc)" ] && [ -x "$(command -v dirname)" ] && [ -x "$(command -v realpath)" ]; then
        libDirectory=$(realpath "$(dirname "$(command -v gcc)")/../lib")
    fi
else
    libFileName=libisar_linux_x64.so
    libDirectory=/usr/lib
    oldLibDir=/usr/local/lib
fi


function printUsage() {
    echo "download.sh [\$1:version] [\$2:os] [\$3:arch]"
    echo
    echo "  Options (use at front only):"
    echo "    --quiet: skipping asking to install to ${libDirectory}"
    echo "    --install: install library to ${libDirectory}"
    echo "    --uninstall: uninstall from ${libDirectory}"
}

if ${printHelp} ; then
    printUsage
    exit 0
fi

function uninstallLib() {
    dir=${1}

    if ! [ -f "${dir}/${libFileName}" ] ; then
        echo "${dir}/${libFileName} doesn't exist, can't uninstall"
        exit 1
    fi

    echo "Removing ${dir}/${libFileName}"

    if [ -x "$(command -v ldconfig)" ]; then
        linkerUpdateCmd="ldconfig ${dir}"
    else
        linkerUpdateCmd=""
    fi

    $sudo bash -c "rm -fv '${dir}/${libFileName}' ; ${linkerUpdateCmd}"
}

if ${uninstallLibrary:-false}; then
    uninstallLib "${libDirectory}"

    if [ -x "$(command -v ldconfig)" ]; then
        libInfo=$(ldconfig -p | grep "${libFileName}" || true)
    else
        libInfo=$(ls -lh ${libDirectory}/* | grep "${libFileName}" || true) # globbing would give "no such file" error
    fi

    if [ -z "${libInfo}" ]; then
        echo "Uninstall successful"
    else
        echo "Uninstall failed, leftover files:"
        echo "${libInfo}"
        exit 1
    fi

    exit 0
fi

downloadDir=download

while getopts v:d: opt
do
    case $opt in
        d) downloadDir=$OPTARG;;
        v) version=$OPTARG;;
        *) printUsage
           exit 1 ;;
   esac
done

conf=$(echo "${os}-${arch}" | tr '[:upper:]' '[:lower:]')   # convert to lowercase

SUPPORTED_PLATFORMS="
macos-universal
" #SUPPORTED_PLATFORMS
if [ -z "$( awk -v key="${conf}" '$1 == key {print $NF}' <<< "$SUPPORTED_PLATFORMS" )" ]; then
    echo "Warning: platform configuration ${conf} is not listed as supported."
    echo "Trying to continue with the download anyway, maybe the list is out of date."
    echo "If that doesn't work you can select the configuration manually (use --help for details)"
    echo "Possible values are:"
    awk '$0 {print " - " $1 }'  <<< "$SUPPORTED_PLATFORMS"
    exit 1
fi

echo "Using configuration ${conf}"

platformName=${conf//-/_}
declare "source_$platformName=libisar_macos.dylib"
declare "target_$platformName=libisar.dylib"

function getLibFile() { 
    local name=$1
    local platform=$2
    local key="${name}_${platform}"

    printf '%s' "${!key}"
}

sourceLibFile="$(getLibFile "source" "${platformName}")"
sourceLibPath="${version}/${sourceLibFile}"

targetDir="${downloadDir}/isar-${version}-${conf}"
targetLibFile="$(getLibFile "target" "${platformName}")"
targetLibPath="$targetDir/$targetLibFile"

downloadUrl="https://github.com/isar/isar-core/releases/download/${sourceLibPath}"
echo "Resolved URL: ${downloadUrl}"
echo "Downloading Isar library version v${version} for ${conf}..."
mkdir -p "$(dirname "${targetLibPath}")"

# Support both curl and wget because their availability is platform dependent
if [ -x "$(command -v curl)" ]; then
    curl --location --fail --output "${targetLibPath}" "${downloadUrl}"
else
    wget --no-verbose --output-document="${targetLibPath}" "${downloadUrl}"
fi

if [[ ! -s ${targetLibPath} ]]; then
    echo "Error: download failed (file ${targetLibPath} does not exist or is empty)"
    exit 1
fi

echo "Downloaded:"
du -h "${targetLibPath}"

if ${quiet} ; then
    if ! ${installLibrary:-false}; then
        echo "Skipping installation to ${libDirectory} in quiet mode"
        if [ -f "${libDirectory}/${libFileName}" ]; then
            echo "However, you have a library there:"
            ls -l "${libDirectory}/${libFileName}"
        fi
    fi
else
    if [ -z "${installLibrary:-}" ] && [ -n "${libDirectory}" ]; then
        read -p "OK. Do you want to install the library into ${libDirectory}? [Y/n] " -r
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z "$REPLY" ]] ; then
            installLibrary=true

            if [ -n "${oldLibDir}" ] && [ -f "${oldLibDir}/${libFileName}" ] ; then
                echo "Found an old installation in ${oldLibDir} but a new one is going to be placed in ${libDirectory}."
                echo "It's recommended to uninstall the old library to avoid problems."
                read -p "Uninstall from old location? [Y/n] " -r
                if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z "$REPLY" ]] ; then
                    uninstallLib ${oldLibDir}
                fi
            fi

        fi
    fi
fi

if ${installLibrary:-false}; then
    echo "Installing ${libDirectory}/${libFileName}"
    $sudo cp "${targetDir}/${libFileName}" ${libDirectory}

    if [ -x "$(command -v ldconfig)" ]; then
        $sudo ldconfig "${libDirectory}"
        libInfo=$(ldconfig -p | grep "${libFileName}" || true)
    else
        libInfo=$(ls -lh ${libDirectory}/* | grep "${libFileName}" || true) # globbing would give "no such file" error
    fi

    if [ -z "${libInfo}" ]; then
        echo "Error installing the library - not found"
        exit 1
    else
        echo "Installed isar libraries:"
        echo "${libInfo}"
    fi
fi