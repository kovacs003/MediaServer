#include "application/app.h"
#include "base/service_handler.h"

int main(int argc, char *argv[]) {
    /* The Big Loop */
    auto svc = base::ServiceHandler<app::Application>::instance();
    int RET_VAL{EXIT_SUCCESS};
    if (!svc.init(RET_VAL)) {
        RET_VAL = svc.start(argc, argv);
    }
    return RET_VAL;
}
