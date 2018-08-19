#include "app.h"

#include <chrono>
#include <thread>
#include <syslog.h>

namespace app {

Application::Application(int argc, char *argv[])
    : has_to_run(true) { }

int Application::run() {
    do {
        syslog(LOG_INFO, "Still running!");
        std::this_thread::sleep_for(std::chrono::seconds(5));
    } while (has_to_run);
    return EXIT_SUCCESS;
}

void Application::stop() {
    syslog(LOG_INFO, "Stop service!");
    has_to_run = false;
}

}  // namespace app
