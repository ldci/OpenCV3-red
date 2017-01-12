#-------------------------------------------------
#
# Project created by QtCreator 2016-01-12T06:02:25
#
#-------------------------------------------------

QT       -= gui

TARGET = cameraLib
TEMPLATE = lib

DEFINES += CAMERALIB_LIBRARY

SOURCES += cameralib.cpp

HEADERS += cameralib.h\
        cameralib_global.h

unix {
    target.path = /usr/local/lib32
    INSTALLS += target
}

#CONFIG += x86
#CONFIG -= x86_64

QMAKE_MAC_SDK= macosx10.11
QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.11

#opencv 3.0.0
#INCLUDEPATH += /usr/local/include
#DEPENDPATH +=/usr/local/include
#LIBS += -L /usr/local/lib
#LIBS+= -lopencv_world


INCLUDEPATH += c:\opencv3\build\include
LIBS+=-L c:\opencv3\build\mingw\bin
LIBS+= -lopencv_core300 -lopencv_highgui300 -lopencv_imgproc300 -lopencv_video300 -lopencv_videoio300 -lopencv_imgcodecs300
