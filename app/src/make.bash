#!/bin/bash

function try () {
"$@" || exit 1
}

function newest_dir () {
    [ -d "$1" ] || return 1
    find "$1" -mindepth 1 -maxdepth 1 -type d | sort -V | tail -n 1
}

function find_ndk () {
    for candidate in "$ANDROID_NDK_HOME" "$ANDROID_NDK_ROOT"; do
        if [ -n "$candidate" ] && [ -d "$candidate/build/cmake" ]; then
            echo "$candidate"
            return 0
        fi
    done

    for sdk in "$ANDROID_SDK_ROOT" "$ANDROID_HOME"; do
        [ -n "$sdk" ] || continue
        if ndk="$(newest_dir "$sdk/ndk")" && [ -n "$ndk" ] && [ -d "$ndk/build/cmake" ]; then
            echo "$ndk"
            return 0
        fi
        if [ -d "$sdk/ndk-bundle/build/cmake" ]; then
            echo "$sdk/ndk-bundle"
            return 0
        fi
    done

    return 1
}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$( cd "$DIR/../.." && pwd )"
MIN_API=${1:-29}
TARGET=$DIR/bin
SOURCE=$DIR/shimakaze
SHIMAKAZE_SOURCE=$SOURCE/shimakaze
SHIMAKAZE_REPOSITORY=${SHIMAKAZE_REPOSITORY:-https://github.com/sxlllslgh/shimakaze.git}
PREFERRED_BRANCH=${SHIMAKAZE_BRANCH:-main}

try mkdir -p "$TARGET/armeabi-v7a" "$TARGET/x86" "$TARGET/arm64-v8a" "$TARGET/x86_64"

ANDROID_NDK_HOME="$(find_ndk)" || {
    echo "ANDROID_NDK_HOME is not set and no NDK was found under ANDROID_SDK_ROOT/ANDROID_HOME"
    exit 1
}
TOOLCHAIN=$(find "$ANDROID_NDK_HOME"/toolchains/llvm/prebuilt/* -maxdepth 1 -type d -print -quit)/bin
[ ! -d "$TOOLCHAIN" ] && echo "LLVM toolchain not found under: $ANDROID_NDK_HOME" && exit 1

command -v cmake >/dev/null 2>&1 || { echo "cmake is required to build shimakaze"; exit 1; }
command -v ninja >/dev/null 2>&1 || { echo "ninja is required to build shimakaze"; exit 1; }

if [ ! -d "$SOURCE/.git" ] && [ ! -f "$SOURCE/.git" ]; then
    if [ -d "$SOURCE" ] && [ -z "$(find "$SOURCE" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
        try git clone --recurse-submodules "$SHIMAKAZE_REPOSITORY" "$SOURCE"
    else
        try git -C "$ROOT" submodule sync -- app/src/shimakaze
        try git -C "$ROOT" submodule update --init --recursive app/src/shimakaze
    fi
fi

try git -C "$SOURCE" remote set-url origin "$SHIMAKAZE_REPOSITORY"
try git -C "$SOURCE" fetch --prune origin

TRACK_BRANCH=$PREFERRED_BRANCH
if ! git -C "$SOURCE" ls-remote --exit-code --heads origin "$TRACK_BRANCH" >/dev/null 2>&1; then
    if git -C "$SOURCE" ls-remote --exit-code --heads origin main >/dev/null 2>&1; then
        TRACK_BRANCH=main
    else
        TRACK_BRANCH=$(git -C "$SOURCE" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')
    fi
fi

[ -z "$TRACK_BRANCH" ] && echo "Unable to determine shimakaze tracking branch" && exit 1
echo "Using shimakaze branch: $TRACK_BRANCH"
try git -C "$SOURCE" checkout --detach "origin/$TRACK_BRANCH"
try git -C "$SOURCE" submodule sync --recursive
try git -C "$SOURCE" submodule update --init --recursive --remote

[ ! -f "$SHIMAKAZE_SOURCE/CMakeLists.txt" ] && echo "Missing shimakaze CMake project: $SHIMAKAZE_SOURCE" && exit 1

for ABI in armeabi-v7a arm64-v8a x86 x86_64; do
    OUT="$TARGET/$ABI/libshimakaze.so"
    if [ -f "$OUT" ]; then
        continue
    fi

    BUILD_DIR="$DIR/.cxx/$ABI"
    echo "Cross compile shimakaze client for $ABI"
    try cmake -S "$DIR" -B "$BUILD_DIR" -G Ninja \
        -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake" \
        -DANDROID_ABI="$ABI" \
        -DANDROID_PLATFORM="android-$MIN_API" \
        -DANDROID_STL=c++_static \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_TESTING=OFF \
        -DFETCHCONTENT_BASE_DIR="$DIR/.deps"
    try cmake --build "$BUILD_DIR" --target shimakaze_android_client --parallel

    BUILT_BINARY="$BUILD_DIR/bin/shimakaze"
    [ ! -f "$BUILT_BINARY" ] && echo "Built shimakaze client was not found: $BUILT_BINARY" && exit 1
    try cp "$BUILT_BINARY" "$OUT"
    try "$TOOLCHAIN/llvm-strip" "$OUT"
done

echo "Successfully build shimakaze"
