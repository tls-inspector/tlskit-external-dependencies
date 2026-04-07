#!/bin/sh
set -e

if [[ "$DEBUG" == "1" ]]; then
    set -x
fi

BUILD_CURL=1
BUILD_OPENSSL=1

while getopts :c:o OPTION; do
    case $OPTION in
        c) BUILD_CURL=0;;
        o) BUILD_OPENSSL=0;;
        ?) echo "Error: Invalid option was specified -$OPTARG";exit 1;;
    esac
done

if [[ "${BUILD_CURL}" == "0" && "${BUILD_OPENSSL}" == "0" ]]; then
    echo "Error: Cannot specify both -c and -o";exit 1;
fi

BUILD_CURL_VERSION="8.19.0"
BUILD_OPENSSL_VERSION="3.6.1"
IOS_TARGET="15.0"

ROOT_PATH=$(realpath .)
BUILD_CURL_PATH=$(realpath builder/curl-ios)
BUILD_OPENSSL_PATH=$(realpath builder/openssl-ios)

if [[ "${BUILD_OPENSSL}" == "1" ]]; then
    # Build OpenSSL
    if [[ -d "${ROOT_PATH}/openssl.xcframework" ]]; then
        rm -rf "${ROOT_PATH}/openssl.xcframework"
    fi
    cd "${BUILD_OPENSSL_PATH}"
    ./build-ios.sh -o "${BUILD_OPENSSL_VERSION}" -i "${IOS_TARGET}" -vsg -- -no-apps -no-argon2 -no-blake2 -no-camellia -no-deprecated -no-md4 -no-hw -no-engine
    cp -fv "${BUILD_OPENSSL_PATH}/openssl-${BUILD_OPENSSL_VERSION}.tar.xz" "${BUILD_CURL_PATH}/openssl-${BUILD_OPENSSL_VERSION}.tar.xz"
    mv -v "${BUILD_OPENSSL_PATH}/openssl.xcframework" "${ROOT_PATH}/openssl.xcframework"
    cd "${ROOT_PATH}"
fi

if [[ "${BUILD_CURL}" == "1" ]]; then
    # Build curl
    if [[ -d "${ROOT_PATH}/curl.xcframework" ]]; then
        rm -rf "${ROOT_PATH}/curl.xcframework"
    fi
    cd "${BUILD_CURL_PATH}"
    ./build-ios.sh -c "${BUILD_CURL_VERSION}" -o "${BUILD_OPENSSL_VERSION}" -i "${IOS_TARGET}" -vsg -- --disable-docs --disable-ntlm --disable-unixsockets --disable-dict --disable-file --disable-ftp --disable-ftps --disable-gopher --disable-gophers --disable-imap --disable-imaps --disable-ipfs --disable-ipns --disable-mqtt --disable-pop3 --disable-pop3s --disable-rtsp --disable-smb --disable-smbs --disable-smtp --disable-smtps --disable-telnet --disable-tftp --disable-ws --disable-wss
    mv -fv "${BUILD_CURL_PATH}/curl.xcframework" "${ROOT_PATH}/curl.xcframework"
    cd "${ROOT_PATH}"
fi
