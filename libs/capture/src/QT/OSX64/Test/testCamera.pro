#-------------------------------------------------
#
# Project created by QtCreator 2016-01-12T07:48:32
#
#-------------------------------------------------

QT       += core

QT       -= gui

TARGET = testCamera
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += main.cpp

QMAKE_MAC_SDK= macosx10.11
QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.11


INCLUDEPATH += /usr/local/include
DEPENDPATH +=/usr/local/include
LIBS += -L /usr/local/lib
LIBS +=-lopencv_world.3.1.0
LIBS +=-lcameralib.1.0.0




