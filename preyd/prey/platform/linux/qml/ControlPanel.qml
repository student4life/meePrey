import QtQuick 1.1
import com.nokia.meego 1.1

Page {
    id: controlPanel
    anchors.fill: parent
    orientationLock : PageOrientation.LockLandscape

    property string nextPage: rb1.checked ? "NewUser" : "ExistingUser"

    //function to goto next page
    function next()
    {
        appWindow.nxtPage()
    }

    Header {
        id: my_header
        anchors{top:parent.top; right:parent.right; left:parent.left}
        info: "Good choice! Have you already registered for a Control Panel account at preyproject.com?"
    }
    ButtonColumn {
        id: control_options
        anchors{
            bottom:parent.bottom; top:my_header.bottom;
            right:parent.right; left:parent.left
            margins:20
        }
        spacing: 20
        Row {
            property alias checked: rb1.checked
            spacing: 10
            Image {
                source:"/opt/prey/pixmaps/conf/newuser.png"
                anchors.verticalCenter: rb1.verticalCenter
            }
            RadioButton {
                id:rb1
                text: "New user"
                style: RadioButtonStyle{}
            }
        }
        Row {
            property alias checked: rb2.checked
            spacing: 10
            Image {
                source:"/opt/prey/pixmaps/conf/olduser.png"
                anchors.verticalCenter: rb2.verticalCenter
            }
            RadioButton {
                id:rb2
                text: "Existing user"
                style: RadioButtonStyle{}
            }
        }
    }
}
