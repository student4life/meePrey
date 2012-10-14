import QtQuick 1.1
import com.nokia.meego 1.1


Item {
    id: my_header
    property alias info: info_text.text
    height: my_icon.height+info_text.height
    Column {
        width:parent.width
        anchors.centerIn: parent
        Image {
            id: my_icon
            source: "/opt/prey/pixmaps/prey-text.png"
            smooth: true
            height: 100
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
        }
        Label {
            id: info_text
            text: info
            wrapMode:Text.Wrap
            anchors{right:parent.right; left:parent.left}
            anchors.margins: 5
        }
    }
}
