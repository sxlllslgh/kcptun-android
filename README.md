## kcptun for Android

[![API](https://img.shields.io/badge/API-36%2B-brightgreen.svg?style=flat)](https://android-arsenal.com/api?level=35)
[![Releases](https://img.shields.io/github/downloads/sxlllslgh/kcptun-android/total.svg)](https://github.com/sxlllslgh/kcptun-android/releases)
[![Language: Kotlin](https://img.shields.io/github/languages/top/sxlllslgh/kcptun-android.svg)](https://github.com/sxlllslgh/kcptun-android/search?l=kotlin)
[![License](https://img.shields.io/github/license/sxlllslgh/kcptun-android.svg)](https://github.com/sxlllslgh/kcptun-android/blob/master/LICENSE)

### PREREQUISITES

* JDK 25
* Go 1.26.1
* Android SDK
  - Android NDK r30

### BUILD

#### 1. Common

* Set environment variable `ANDROID_HOME` to `/path/to/android-sdk`
* Clone the repo using `git clone --recurse-submodules https://github.com/sxlllslgh/kcptun-android.git` or update submodules using `git submodule update --init --recursive`

#### 2. Windows specified (Linux/Mac OS skip)
Use GitBash or WSL to run `app/src/make.bash`, remember change NDK toolchain path defined in `make.bash` Line 18 to:
```bash
TOOLCHAIN=$(find "$ANDROID_NDK_HOME" -mindepth 1 -maxdepth 1 -type d | sort -V | tail -n 1)/toolchains/llvm/prebuilt/windows-x86_64/bin
```

#### 3. Just Build
Build it using Android Studio or gradle script.

## OPEN SOURCE LICENSES

<ul>
    <li>kcptun: <a href="https://github.com/shadowsocks/kcptun/blob/shadowsocks/LICENSE.md">MIT</a></li>
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
