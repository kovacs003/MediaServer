
# to find our own modules
MS_LD_PATH += -L$$DESTDIR

# link stdc++ statically to hook the throw statements
contains(QMAKE_COMPILER_DEFINES,__GNUC__) {
# TODO FIX_ME cxa_throw should be hooked using a dll proxy
# It is not okay to link libstdc++ statically while the application uses dynamic libraries
    LIBS += -static-libstdc++
    LIBS += -Wl,-wrap,__cxa_throw
}

LIBS += -latomic

# boost and other 3rd parties
win32 {
    MS_LD_PATH += -L$$ROOTDIR/lib
    MS_LD_PATH += -L$${DEVENV_ROOT}/boost/lib
    MS_LD_PATH += -L$${LAPACK_DIR}/lib
    MS_LD_PATH += -L$${LOG4CPP_DIR}/lib

    CONFIG(release, debug|release) {
        BOOST_VERSION_SUFFIX=mgw72-mt-1_65
    }
    CONFIG(debug, debug|release) {
        BOOST_VERSION_SUFFIX=mgw72-mt-d-1_65
    }

    MS_LD_FLAGS +=-lboost_thread-$${BOOST_VERSION_SUFFIX}
    MS_LD_FLAGS +=-lboost_system-$${BOOST_VERSION_SUFFIX}
    MS_LD_FLAGS +=-lboost_serialization-$${BOOST_VERSION_SUFFIX}
    # add socket for boost asio
    MS_LD_FLAGS += -lws2_32 -lmswsock
    # add logger
    MS_LD_FLAGS += -llog4cpp
}
unix {
    MS_LD_PATH += -L"/usr/lib/x86_64-linux-gnu/"
    MS_LD_FLAGS += -lboost_thread
    MS_LD_FLAGS += -lboost_system
    MS_LD_FLAGS += -lboost_filesystem
    MS_LD_FLAGS += -latomic -llog4cpp
}

LIBS += $${MS_LD_PATH} $${MS_LD_FLAGS}

# save the release version of the exe and shared libraries with debug info using the '_unstripped' suffix in the name
TARGET_EXT =
IS_EXE_OR_SHARED_LIB = 0

contains(TEMPLATE, app) {
IS_EXE_OR_SHARED_LIB = 1
win32:TARGET_EXT = .exe
}
contains(CONFIG, dll) {
IS_EXE_OR_SHARED_LIB = 1
win32:TARGET_EXT = .dll
unix:TARGET_EXT = .so
}

equals(IS_EXE_OR_SHARED_LIB, 1) {
    # this removes the default -s linker option that would strip the executable
    QMAKE_LFLAGS_RELEASE=
    QMAKE_LFLAGS_RELEASE = -Wl,-Map=$${DESTDIR}/$${TARGET}.map

    CONFIG(release,debug|release) {
        # now do the stripping manually while preserving the unstripped exe
        TARGET_FULL_PATH = $$shell_path($${DESTDIR}/$${TARGET}$${TARGET_EXT})
        TARGET_UNSTRIPPED_FULL_PATH = $$shell_path($${DESTDIR}/$${TARGET}_unstripped$${TARGET_EXT})

        QMAKE_POST_LINK += @echo STRIPPING $${TARGET} &
        QMAKE_POST_LINK += @call $(MOVE) $${TARGET_FULL_PATH} $${TARGET_UNSTRIPPED_FULL_PATH} >nul &
        QMAKE_POST_LINK += @call strip --strip-all --enable-deterministic-archives --preserve-dates $${TARGET_UNSTRIPPED_FULL_PATH} -o $${TARGET_FULL_PATH} &
        QMAKE_POST_LINK += @echo STRIPPING $${TARGET} FINISHED &
    }
}

CONFIG(coverage){
    QMAKE_LFLAGS_RELEASE += --coverage
}
