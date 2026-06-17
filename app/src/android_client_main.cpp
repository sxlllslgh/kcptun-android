#include "shimakaze/client.hpp"
#include "shimakaze/config.hpp"
#include "shimakaze/diagnostics.hpp"
#include "shimakaze/logger.hpp"
#include "shimakaze/stats.hpp"

#include <boost/asio.hpp>

#include <cstdlib>
#include <exception>
#include <iostream>
#include <string>
#include <string_view>
#include <vector>

namespace {

std::string getenv_string(const char* name)
{
    const char* value = std::getenv(name);
    return value == nullptr ? std::string() : std::string(value);
}

std::string join_host_port(std::string host, const std::string& port)
{
    if (host.find(':') != std::string::npos && !host.starts_with('[')) {
        host = '[' + host + ']';
    }
    return host + ':' + port;
}

void append_plugin_options(std::vector<std::string>& args)
{
    const std::string options = getenv_string("SS_PLUGIN_OPTIONS");
    std::size_t start = 0;
    while (start <= options.size()) {
        const auto end = options.find(';', start);
        const auto token = options.substr(start, end == std::string::npos ? std::string::npos : end - start);
        start = end == std::string::npos ? options.size() + 1 : end + 1;

        if (token.empty() || token.starts_with("__")) {
            continue;
        }

        const auto eq = token.find('=');
        if (eq == std::string::npos) {
            args.push_back("--" + token);
        } else {
            args.push_back("--" + token.substr(0, eq));
            args.push_back(token.substr(eq + 1));
        }
    }

    const auto local_host = getenv_string("SS_LOCAL_HOST");
    const auto local_port = getenv_string("SS_LOCAL_PORT");
    if (!local_host.empty() && !local_port.empty()) {
        args.emplace_back("--localaddr");
        args.push_back(join_host_port(local_host, local_port));
    }

    const auto remote_host = getenv_string("SS_REMOTE_HOST");
    const auto remote_port = getenv_string("SS_REMOTE_PORT");
    if (!remote_host.empty() && !remote_port.empty()) {
        args.emplace_back("--remoteaddr");
        args.push_back(join_host_port(remote_host, remote_port));
    }
}

shimakaze::ClientConfig parse_android_client_config(int argc, char* argv[])
{
    std::vector<std::string> storage;
    storage.reserve(static_cast<std::size_t>(argc) + 16);
    for (int i = 0; i < argc; ++i) {
        storage.emplace_back(argv[i]);
    }
    append_plugin_options(storage);

    std::vector<char*> adapted_argv;
    adapted_argv.reserve(storage.size());
    for (auto& arg : storage) {
        adapted_argv.push_back(arg.data());
    }
    return shimakaze::parse_client_config(static_cast<int>(adapted_argv.size()), adapted_argv.data());
}

} // namespace

int main(int argc, char* argv[])
{
    using namespace shimakaze;

    try {
        auto config = parse_android_client_config(argc, argv);
        Logger::instance().set_quiet(config.quiet);
        Logger::instance().set_level(config.loglevel);
        Logger::instance().set_file(config.log);
        log_effective_client_config(config);
        log_compatibility_notes(config, true);

        boost::asio::io_context io;
        auto snmp_logger = start_snmp_logger(io, config.snmplog, config.snmpperiod);
        auto diagnostics = start_diagnostics_server(io, config.pprof);
        (void)snmp_logger;
        (void)diagnostics;

        boost::asio::signal_set signals(io, SIGINT, SIGTERM);
        signals.async_wait([&io](const boost::system::error_code&, int) {
            Logger::instance().info("signal received, stopping");
            io.stop();
        });

        Client client(io, std::move(config));
        client.start();
        io.run();
        return 0;
    } catch (const HelpRequested&) {
        std::cout << client_usage(argv[0]);
        return 0;
    } catch (const VersionRequested&) {
        std::cout << version << '\n';
        return 0;
    } catch (const std::exception& error) {
        std::cerr << "client: " << error.what() << '\n';
        std::cerr << client_usage(argv[0]);
        return 1;
    }
}
