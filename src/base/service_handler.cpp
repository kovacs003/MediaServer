#include "service_handler.h"

#include <cerrno>
#include <csignal>
#include <cstdlib>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <syslog.h>
#include <unistd.h>

#include <application/app.h>

namespace base {

template<class APP>
bool ServiceHandler<APP>::init(int& ret_val) {
    /* Our process ID and Session ID */
    pid_t pid, sid;

    /* Fork off the parent process */
    pid = fork();
    if (pid < 0) {
        ret_val = EXIT_FAILURE;
        return true;
    }
    /* If we got a good PID, then
       we can exit the parent process. */
    if (pid > 0) {
        ret_val = EXIT_SUCCESS;
        return true;
    }

    /* Change the file mode mask */
    umask(0);

    /* Open any logs here */
    openlog(APP_NAME, LOG_PID|LOG_CONS, LOG_USER);

    /* Create a new SID for the child process */
    sid = setsid();
    if (sid < 0) {
        syslog(LOG_ERR, "setsid failed!");
        closelog();
        ret_val = EXIT_FAILURE;
        return true;
    }

    /* Install signal handler */
    signal(SIGCHLD, SIG_IGN);
    signal(SIGHUP, SIG_IGN);
    signal(SIGTERM, &handle_signal);

    /* Change the current working directory */
    if ((chdir("/")) < 0) {
        syslog(LOG_ERR, "chdir failed");
        closelog();
        ret_val = EXIT_FAILURE;
        return true;
    }

    /* Close out the standard file descriptors */
    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);

    /* Daemon-specific initialization goes here */

    ret_val = EXIT_SUCCESS;
    return false;
}

template<class APP>
ServiceHandler<APP>::~ServiceHandler() {
    syslog(LOG_INFO, "Daemon stopped!");
    closelog();
}

template<class APP>
ServiceHandler<APP> ServiceHandler<APP>::instance() {
    static ServiceHandler<APP> svc;
    return svc;
}

template<class APP>
void ServiceHandler<APP>::handle_signal(int signum) {
    syslog(LOG_INFO, "SIGNAL: %i", signum);
    if (signum == SIGTERM && app) {
        app->stop();
    }
}

template class ServiceHandler<app::Application>;

}  // namespace base
