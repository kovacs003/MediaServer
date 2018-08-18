#ifndef SERVICE_HANDLER_H
#define SERVICE_HANDLER_H

#include <memory>

namespace base {

template<class APP>
class ServiceHandler {
    ServiceHandler() = default;
    static void handle_signal(int signum);

    static std::unique_ptr<APP> app;
public:
    ~ServiceHandler();
    static ServiceHandler<APP> instance();
    bool init(int& ret_val);

    template<class... Args>
    int start(Args... args) {
        if (!app) {
            app = std::make_unique<APP>(std::forward<Args>(args)...);
            return app->run();
        }
        return EXIT_SUCCESS;
    }
};

template<class APP>
std::unique_ptr<APP> ServiceHandler<APP>::app = nullptr;

}  // namespace base

#endif // SERVICE_HANDLER_H
