# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-adac-traffic

CONFIG += sailfishapp

SOURCES += src/harbour-adac-traffic.cpp \
    src/adacbackend.cpp \
    src/trafficmanager.cpp

DEFINES += VERSION_NUMBER=\\\"$$(VERSION_NUMBER)\\\"

DISTFILES += qml/harbour-adac-traffic.qml \
    qml/components/Footer.qml \
    qml/components/Header.qml \
    qml/components/IncidentSign.qml \
    qml/components/thirdparty/AboutDescription.qml \
    qml/components/thirdparty/AboutIconLabel.qml \
    qml/components/thirdparty/LoadingIndicator.qml \
    qml/cover/CoverPage.qml \    \
    qml/js/constants.js \
    qml/js/functions.js \
    qml/pages/AboutPage.qml \
    qml/pages/OverviewPage.qml \
    qml/pages/icons/github.svg \
    qml/pages/icons/paypal.svg \
    qml/icons/de/*.svg \
    qml/icons/ch/*.svg \
    qml/icons/type/*.svg \
    qml/icons/empty.svg \
    qml/icons/type/baustelle.png \
    qml/pages/SettingsPage.qml \
    qml/pages/icons/github.svg \
    rpm/harbour-adac-traffic.changes.in \
    rpm/harbour-adac-traffic.changes.run.in \
    rpm/harbour-adac-traffic.spec \
    translations/*.ts \
    harbour-adac-traffic.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-adac-traffic-de.ts

HEADERS += \
    src/adacbackend.h \
    src/constants.h \
    src/trafficmanager.h
