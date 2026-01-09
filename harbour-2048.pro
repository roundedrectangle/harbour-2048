TARGET = harbour-2048

CONFIG += sailfishapp_qml

DISTFILES += qml/* \
    rpm/harbour-2048.changes.in \
    rpm/harbour-2048.changes.run.in \
    rpm/harbour-2048.spec \
    translations/*.ts \
    harbour-2048.desktop

# TODO: recreate the icon and make it available for all sizes
#SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172
SAILFISHAPP_ICONS = 86x86

CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-2048-ru.ts
