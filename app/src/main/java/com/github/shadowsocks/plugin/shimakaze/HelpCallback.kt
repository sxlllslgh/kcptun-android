package com.github.shadowsocks.plugin.shimakaze

import com.github.shadowsocks.plugin.PluginOptions

class HelpCallback : com.github.shadowsocks.plugin.HelpCallback() {
    override fun produceHelpMessage(options: PluginOptions): CharSequence =
        ProcessBuilder(applicationInfo.nativeLibraryDir + "/libshimakaze.so", "--help")
            .redirectErrorStream(true)
            .start()
            .inputStream.bufferedReader().useLines { lines ->
                lines.dropWhile { it != "Shimakaze client options:" }
                    .drop(1)
                    .takeWhile { it.isNotBlank() }
                    .map { it.trim() }
                    .filter {
                        !it.startsWith("-l, --localaddr ") &&
                                !it.startsWith("-r, --remoteaddr ") &&
                                !it.startsWith("--log ") &&
                                !it.startsWith("--quiet") &&
                                !it.startsWith("-c ") &&
                                !it.startsWith("-h, --help")
                    }
                    .joinToString("\n")
                    .replace(Regex(" {2,}"), " ")
                    .replace("--", "")
            }
}
