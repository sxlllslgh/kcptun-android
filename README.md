## kcptun for Android

[![API](https://img.shields.io/badge/API-35%2B-brightgreen.svg?style=flat)](https://android-arsenal.com/api?level=35)
[![Releases](https://img.shields.io/github/downloads/sxlllslgh/kcptun-android/total.svg)](https://github.com/sxlllslgh/kcptun-android/releases)
[![Language: Kotlin](https://img.shields.io/github/languages/top/sxlllslgh/kcptun-android.svg)](https://github.com/sxlllslgh/kcptun-android/search?l=kotlin)
[![License](https://img.shields.io/github/license/sxlllslgh/kcptun-android.svg)](https://github.com/sxlllslgh/kcptun-android/blob/master/LICENSE)

### PREREQUISITES

* JDK 21
* Go 1.24.2
* Android SDK
  - Android NDK r29

### BUILD

You can check whether the latest commit builds under UNIX environment.

* Set environment variable `ANDROID_HOME` to `/path/to/android-sdk`
* (optional) Set environment variable `ANDROID_NDK_HOME` to `/path/to/android-ndk` (default: `$ANDROID_HOME/ndk-bundle`)
* Clone the repo using `git clone --recurse-submodules <repo>` or update submodules using `git submodule update --init --recursive`
* Build it using Android Studio or gradle script

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
