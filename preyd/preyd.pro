#-------------------------------------------------
#
# Project created by QtCreator 2012-09-27T08:40:38
#
#-------------------------------------------------

QT       += core

QT       -= gui

TARGET = preyd
CONFIG   += console
CONFIG   -= app_bundle
CONFIG   += mobility
MOBILITY += systeminfo

TEMPLATE = app


SOURCES += main.cpp \
    timedscript.cpp

contains(MEEGO_EDITION,harmattan) {
    target.path = /opt/prey/bin
    INSTALLS += target
}

HEADERS += \
    timedscript.h

folder_01.source = prey
folder_01.target =
DEPLOYMENTFOLDERS += folder_01

for(deploymentfolder, DEPLOYMENTFOLDERS) {
    item = item$${deploymentfolder}
    itemsources = $${item}.sources
    $$itemsources = $$eval($${deploymentfolder}.source)
    itempath = $${item}.path
    $$itempath= $$eval($${deploymentfolder}.target)
    export($$itemsources)
    export($$itempath)
    DEPLOYMENT += $$item
}

installPrefix = /opt
for(deploymentfolder, DEPLOYMENTFOLDERS) {
    item = item$${deploymentfolder}
    itemfiles = $${item}.files
    $$itemfiles = $$eval($${deploymentfolder}.source)
    itempath = $${item}.path
    $$itempath = $${installPrefix}/$$eval($${deploymentfolder}.target)
    export($$itemfiles)
    export($$itempath)
    INSTALLS += $$item
}

#install desktop file and icon for prey-config
desktopfile.files = prey_config_harmattan.desktop
desktopfile.path = /usr/share/applications
icon.files = prey_config80.png
icon.path = /usr/share/icons/hicolor/80x80/apps
svg.files = prey_config.svg
svg.path = /usr/share/icons/hicolor/scalable/apps
export(icon.files)
export(icon.path)
export(svg.files)
export(svg.path)
export(desktopfile.files)
export(desktopfile.path)
INSTALLS += icon svg desktopfile

daemonconf.path = /etc/init/apps
daemonconf.files = preyd.conf
INSTALLS += daemonconf
