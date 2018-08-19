
# CONFIG -= depend_includepath
CONFIG -= debug_and_release

# disable Qt by default and enable it in the modules project file after including this file if it is needed
CONFIG -= qt

BUILD_ROOT_DIR = $${ROOTDIR}/build
BUILD_TYPE_PREFIX=

DESTDIR =

CONFIG(debug, debug|release) {
    DESTDIR = $${BUILD_ROOT_DIR}/$${BUILD_TYPE_PREFIX}debug
}
CONFIG(release, debug|release) {
    DESTDIR = $${BUILD_ROOT_DIR}/$${BUILD_TYPE_PREFIX}release
}
CONFIG(release) CONFIG(force_debug_info) {
    DESTDIR = $${BUILD_ROOT_DIR}/$${BUILD_TYPE_PREFIX}profile
}
CONFIG(coverage){
    DESTDIR = $${BUILD_ROOT_DIR}/$${BUILD_TYPE_PREFIX}coverage
}

isEmpty(DESTDIR) {
    error("You should set the 'DESTDIR' variable for your current build configuration!")
}

UI_DIR      = $${DESTDIR}/intermediate/.ui
MOC_DIR     = $${DESTDIR}/intermediate/$${PROJECT_NAME}/.moc
RCC_DIR     = $${DESTDIR}/intermediate/$${PROJECT_NAME}/.rcc
OBJECTS_DIR = $${DESTDIR}/intermediate/$${PROJECT_NAME}/.obj

ENGINE_PCH_DIR = $${DESTDIR}/pch/engine
QT_GUI_PCH_DIR = $${DESTDIR}/pch/qt_gui
TESTS_PCH_DIR = $${DESTDIR}/pch/tests

QMAKE_CXXFLAGS_DEBUG = -g -Og
QMAKE_CXXFLAGS_RELEASE = -O3
QMAKE_CXXFLAGS += -std=c++1z
QMAKE_CXXFLAGS += -fno-pie
#QMAKE_CXXFLAGS += -Wa,-mbig-obj
QMAKE_CXXFLAGS += -Wno-unused-local-typedefs -Winvalid-pch
QMAKE_CXXFLAGS += -fvisibility=hidden -fvisibility-inlines-hidden

# compile release with minimal debug information
QMAKE_CXXFLAGS_RELEASE += -g1

CONFIG(coverage){
    CONFIG += release
    QMAKE_CXXFLAGS_RELEASE = -Og
    QMAKE_CXXFLAGS_RELEASE += --coverage
}
CONFIG(release, debug|release) {
    DEFINES += NDEBUG
}

unix {
    BOOST_INCLUDE = /usr/include/boost
    LOG4CPP_DIR += /usr/include/log4cpp
    SFML_DIR += /usr/include/SFML
}
win32 {
    DEVENV_ROOT = c:/devenv_01

    BOOST_INCLUDE = $${DEVENV_ROOT}/boost
    LOG4CPP_DIR = $${DEVENV_ROOT}/log4cpp
    SFML_DIR = $${DEVENV_ROOT}/sfml
}

INCLUDEPATH += $$BOOST_INCLUDE $${SFML_DIR}
# suppress boost warnings
QMAKE_CXXFLAGS += \
    -isystem $${BOOST_INCLUDE} \
    -isystem $${SFML_DIR} \
    -isystem $${LOG4CPP_DIR}

INCLUDEPATH += $${ROOTDIR}/src

DEFINES += BOOST_NO_AUTO_PTR=1
DEFINES += BOOST_SYSTEM_NO_DEPRECATED=1
DEFINES += BIND_FORTRAN_LOWERCASE_UNDERSCORE=1
DEFINES += BOOST_PARAMETER_MAX_ARITY=7
DEFINES += LOG4CPP_NO_THREADING
DEFINES += APP_NAME=\\\"MediaServer\\\"
