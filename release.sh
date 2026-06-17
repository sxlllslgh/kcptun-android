#!/bin/bash

release=$1
cp app/build/outputs/apk/release/app-armeabi-v7a-release.apk shimakaze-armeabi-v7a-${release}.apk
cp app/build/outputs/apk/release/app-arm64-v8a-release.apk shimakaze-arm64-v8a-${release}.apk
cp app/build/outputs/apk/release/app-x86-release.apk shimakaze-x86-${release}.apk
cp app/build/outputs/apk/release/app-x86_64-release.apk shimakaze-x86_64-${release}.apk
cp app/build/outputs/apk/release/app-universal-release.apk shimakaze-universal-${release}.apk
