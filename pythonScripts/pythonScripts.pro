TEMPLATE = lib

contains(MEEGO_EDITION,harmattan) {
    target.path = /opt/prey/bin
    target.files = bin/showcoordinates
    target.files += bin/takePhoto \
                    bin/takeVid
    INSTALLS += target
}
