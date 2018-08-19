#ifndef APPLICATION_H
#define APPLICATION_H

namespace app {

struct Application {
    Application(int argc, char* argv[]);
    int run();
    void stop();

private:
    bool has_to_run;
};

}  // namespace app

#endif // APPLICATION_H
