// Starter stub for a `bar-widget` entry point.
// Before building this out, read a real built-in widget for the actual
// Quickshell/plugin API in use on this system:
//   ls "$OMARCHY_PATH/shell/plugins/"
//   cat "$OMARCHY_PATH/shell/plugins/<name>/"*.qml
// Do not treat the imports/APIs below as authoritative — copy patterns
// from an existing widget instead of guessing at the API surface.

import QtQuick

Item {
    id: root

    Text {
        anchors.centerIn: parent
        text: "Hello"
    }
}
