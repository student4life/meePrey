#-------------------------------------------------
#
# Project created by QtCreator 2012-09-27T16:24:40
#
#-------------------------------------------------

QT       += core

QT       -= gui

TARGET = mediaplay
CONFIG   += console
CONFIG   += mobility
MOBILITY += multimedia
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += main.cpp

contains(MEEGO_EDITION,harmattan) {
    target.path = /opt/prey/bin
    INSTALLS += target
}
