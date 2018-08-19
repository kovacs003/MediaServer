ROOTDIR = $$PWD
PROJECT_FILE = $$_PRO_FILE_
PROJECT_FILE_DIR = $$_PRO_FILE_PWD_
PROJECT_NAME = application

TARGET = MediaServer
TEMPLATE = app

include($$ROOTDIR/buildconfigs/common.pri)
include($$ROOTDIR/buildconfigs/common_linker_flags.pri)

HEADERS += \
    src/application/app.h \
    src/base/service_handler.h \
    src/utility/scope_guard.h

SOURCES += src/main.cpp \
    src/application/app.cpp \
    src/base/service_handler.cpp

