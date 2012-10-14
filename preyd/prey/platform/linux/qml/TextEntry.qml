import QtQuick 1.1
import com.nokia.meego 1.1


Item {
    id: my_entry
    property alias label: my_label.text
    property alias text: my_text.text
    property alias echoMode: my_text.echoMode
    height: entry_row.height
    Row {
        id: entry_row
        spacing: 20
        Label {
            id: my_label
            width: 150
            font.bold: true
            anchors.verticalCenter: my_text.verticalCenter
        }
        TextField {
            id: my_text
            width: 400
            inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
        }
    }
}

