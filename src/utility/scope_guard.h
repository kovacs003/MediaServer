#ifndef UTILITIES_SCOPE_GUARD_H
#define UTILITIES_SCOPE_GUARD_H

#include <functional>

namespace utility {

template<typename Functor>
struct scope_guard {
    scope_guard(Functor f)
        : functor(std::move(f)),
          active(true) {
    }

    scope_guard(scope_guard&& other)
        : functor(std::move(other.functor)),
          active(other.active) {
        other.active = false;
    }

    scope_guard(const scope_guard& other) = delete;
    scope_guard& operator=(const scope_guard&) = delete;
    scope_guard& operator=(scope_guard&&) = delete;

    ~scope_guard() {
        if(active) {
            functor();
        }
    }

private:
    Functor functor;
    bool active;
};

template<typename F>
scope_guard<std::decay_t<F>>
make_scope_guard(F&& f) {
    return { std::forward<F>(f) };
}

} // namespace utility

#endif // UTILITIES_SCOPE_GUARD_H
