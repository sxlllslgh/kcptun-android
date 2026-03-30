#!/bin/bash

function try () {
"$@" || exit -1
}

if [ -z "$ANDROID_NDK_HOME" ]; then
    if [ -n "$ANDROID_SDK_ROOT" ] && [ -d "$ANDROID_SDK_ROOT/ndk" ]; then
        ANDROID_NDK_HOME="$ANDROID_SDK_ROOT/ndk-bundle"
    elif [ -n "$ANDROID_HOME" ] && [ -d "$ANDROID_HOME/ndk" ]; then
        ANDROID_NDK_HOME="$ANDROID_HOME/ndk"
    fi
fi

[ -z "$ANDROID_NDK_HOME" ] && echo "ANDROID_NDK_HOME is not set and no NDK was found under ANDROID_SDK_ROOT/ANDROID_HOME" && exit -1
[ ! -d "$ANDROID_NDK_HOME" ] && echo "ANDROID_NDK_HOME does not exist: $ANDROID_NDK_HOME" && exit -1

TOOLCHAIN=$(find "$ANDROID_NDK_HOME"/toolchains/llvm/prebuilt/* -maxdepth 1 -type d -print -quit)/bin
[ ! -d "$TOOLCHAIN" ] && echo "LLVM toolchain not found under: $ANDROID_NDK_HOME" && exit -1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MIN_API=$1
TARGET=$DIR/bin

try mkdir -p $TARGET/armeabi-v7a $TARGET/x86 $TARGET/arm64-v8a $TARGET/x86_64

export GOPATH=$DIR

[ ! -d "$DIR/kcptun/client" ] && echo "Missing submodule directory: $DIR/kcptun/client" && exit -1
try pushd "$DIR/kcptun/client"

git -C $DIR/kcptun checkout v20260314
git -C $DIR/kcptun apply $DIR/patches/kcptun.patch

if [ ! -f "$TARGET/armeabi-v7a/libkcptun.so" ] || [ ! -f "$TARGET/arm64-v8a/libkcptun.so" ] || [ ! -f "$TARGET/x86/libkcptun.so" ] || [ ! -f "$TARGET/x86_64/libkcptun.so" ]; then

    echo "Download dependencies for kcptun"
    try go mod download
    echo "Cross compile kcptun for arm"
    if [ ! -f "$TARGET/armeabi-v7a/libkcptun.so" ]; then
        try env CGO_ENABLED=1 CC=$TOOLCHAIN/armv7a-linux-androideabi${MIN_API}-clang GOOS=android GOARCH=arm GOARM=7 go build -trimpath -ldflags="-s -w" -o client .
        try $TOOLCHAIN/llvm-strip client
        try mv client $TARGET/armeabi-v7a/libkcptun.so
    fi

    echo "Cross compile kcptun for arm64"
    if [ ! -f "$TARGET/arm64-v8a/libkcptun.so" ]; then
        try env CGO_ENABLED=1 CC=$TOOLCHAIN/aarch64-linux-android${MIN_API}-clang GOOS=android GOARCH=arm64 go build -trimpath -ldflags="-s -w" -o client .
        try $TOOLCHAIN/llvm-strip client
        try mv client $TARGET/arm64-v8a/libkcptun.so
    fi

    echo "Cross compile kcptun for 386"
    if [ ! -f "$TARGET/x86/libkcptun.so" ]; then
        try env CGO_ENABLED=1 CC=$TOOLCHAIN/i686-linux-android${MIN_API}-clang GOOS=android GOARCH=386 go build -trimpath -ldflags="-s -w" -o client .
        try $TOOLCHAIN/llvm-strip client
        try mv client $TARGET/x86/libkcptun.so
    fi

    echo "Cross compile kcptun for amd64"
    if [ ! -f "$TARGET/x86_64/libkcptun.so" ]; then
        try env CGO_ENABLED=1 CC=$TOOLCHAIN/x86_64-linux-android${MIN_API}-clang GOOS=android GOARCH=amd64 go build -trimpath -ldflags="-s -w" -o client .
        try $TOOLCHAIN/llvm-strip client
        try mv client $TARGET/x86_64/libkcptun.so
    fi

fi

    try popd

echo "Successfully build kcptun"