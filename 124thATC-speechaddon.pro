

#
# ExtPlane plugin build configuration
#
# Change to -DXPLM200=1 for SDK 2.0.0 (X-Plane 9)
QMAKE_CXXFLAGS += -DXPLM210=1
QMAKE_CXXFLAGS += -DXPLM200=1

# If your X-Plane SDK is in another directory, add or change it here:
INCLUDEPATH += $$(HOME)/SDK/CHeaders/XPLM
INCLUDEPATH += ../XPlaneSDK/CHeaders/XPLM
INCLUDEPATH += SDK/CHeaders/XPLM
INCLUDEPATH += ../XPlane-SDK/CHeaders/XPLM

# You should not need to touch anything below this for normal build

# Detailed X-Plane plugin build instructions here:
# http://www.xsquawkbox.net/xpsdk/mediawiki/BuildInstall

QT       -= qt gui core network

CONFIG   += console warn_on release shared
CONFIG   -= app_bundle

TEMPLATE = lib

TARGET = 124thATC-speechaddon

QMAKE_CXXFLAGS += -fPIC
QMAKE_LFLAGS += -shared -fPIC
#  -static-libgcc  <- fails on mac

CONFIG(debug, debug|release) {
    # Debug
    message("124thATC-speechaddon Debug Build")
} else {
    # Release
    message("124thATC-speechaddon Release Build")
    DEFINES += QT_NO_DEBUG
    DEFINES += QT_NO_DEBUG_OUTPUT
}

unix:!macx {
     DEFINES += APL=0 IBM=0 LIN=1
}

macx {
     DEFINES += APL=1 IBM=0 LIN=0
     QMAKE_LFLAGS += -dynamiclib
     # -flat_namespace -undefined warning <- not needed or recommended anymore.

     # Build for multiple architectures.
     # The following line is only needed to build universal on PPC architectures.
     # QMAKE_MAC_SDK=/Devloper/SDKs/MacOSX10.4u.sdk
     # This line defines for wich architectures we build.
     CONFIG += x86 ppc
     QMAKE_LFLAGS += -F../XPlaneSDK/Libraries/Mac
     LIBS += -framework XPLM
}

win32 {
    !contains(QMAKE_HOST.arch, x86_64) {
        message("Windows Platform (x86)")
        LIBS += -lXPLM -lXPWidgets
    } else {
        message("Windows Platform (x86_64)")
        LIBS += -lXPLM_64 -lXPWidgets_64
    }
    DEFINES += APL=0 IBM=1 LIN=0
    LIBS += -L../XPlaneSDK/Libraries/Win
    DEFINES += NOMINMAX #Qt5 bug
}

QMAKE_POST_LINK += $(COPY_FILE) $(TARGET) 124thATC-speechaddon.xpl
QMAKE_CLEAN += 124thATC-speechaddon.xpl

SOURCES += \
    124thATC-speechaddon.cpp

OTHER_FILES += README.md
