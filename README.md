## shimakaze for Android

[![API](https://img.shields.io/badge/API-29%2B-brightgreen.svg?style=flat)](https://android-arsenal.com/api?level=29)
[![Releases](https://img.shields.io/github/downloads/sxlllslgh/shimakaze-android/total.svg)](https://github.com/sxlllslgh/shimakaze-android/releases)
[![Language: Kotlin](https://img.shields.io/github/languages/top/sxlllslgh/shimakaze-android.svg)](https://github.com/sxlllslgh/shimakaze-android/search?l=kotlin)
[![License](https://img.shields.io/github/license/sxlllslgh/shimakaze-android.svg)](https://github.com/sxlllslgh/shimakaze-android/blob/main/LICENSE)

### PREREQUISITES

* JDK 25
* CMake 4.3+
* Ninja
* Android SDK
  - Android NDK r29 or newer

### BUILD

#### 1. Common

* Set environment variable `ANDROID_HOME` to `/path/to/android-sdk`
* Clone the repo using `git clone --recurse-submodules https://github.com/sxlllslgh/shimakaze-android.git` or update submodules using `git submodule update --init --recursive`
* The native shimakaze dependency is updated from `https://github.com/sxlllslgh/shimakaze.git` during the Gradle build. The build script tracks `main` by default; override it with `SHIMAKAZE_BRANCH` when needed.

#### 2. Windows specified (Linux/Mac OS skip)
Use WSL to run `app/src/make.bash`. Native builds from Gradle are supported on Linux/macOS CI; Android Studio on Windows can still build the Kotlin/Android part after the native binaries exist.

#### 3. Just Build
Build it using Android Studio or gradle script.

GitHub Actions also builds release APK artifacts on push, pull request, and manual dispatch.

## OPEN SOURCE LICENSES

<ul>
    <li>shimakaze: <a href="https://github.com/sxlllslgh/shimakaze">GPL-3.0-or-later</a></li>
    <li>KCP: <a href="https://github.com/skywind3000/kcp">MIT</a></li>
</ul>

### LICENSE

Copyright (C) 2017 by Max Lv <<max.c.lv@gmail.com>>  
Copyright (C) 2017 by Mygod Studio <<contact-shadowsocks-android@mygod.be>>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
