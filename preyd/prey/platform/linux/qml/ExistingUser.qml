import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1

Page {
    id: existingUser
    anchors.fill: parent
    orientationLock : PageOrientation.LockLandscape

    property string nextPage: existingDevice.checked ? "ExistingDevice" : ""

    //function to goto next page
    function next()
    {
        vars.email = my_email.text
        vars.password = my_password.text
        if (main.get_existing_user(true))
            appWindow.nxtPage()
    }

    //function to apply Existing user and New device settings
    function apply()
    {
        vars.email = my_email.text
        vars.password = my_password.text
        main.get_existing_user(false)
    }

    Flickable {
            id: button_flick
        anchors.fill:parent
        contentWidth: parent.width
        contentHeight: col1.height+my_header.height+30
        flickableDirection: Flickable.VerticalFlick
        clip: true
        Header {
            id: my_header
            anchors{top:parent.top; right:parent.right; left:parent.left}
            info: "Please type in your login credentials. This information is never stored, and only used for adding your device to your Control Panel account."
        }

        Column {
            id: col1
            spacing: 30
            anchors {
                left: parent.left
                top: my_header.bottom
                leftMargin: 20
                topMargin: 20
            }

            TextEntry {
                id: my_email
                width: 400
                label: "Email"
            }
            TextEntry {
                id: my_password
                width: 400
                label: "Password"
                echoMode: TextInput.Password
            }
            ButtonRow {
                spacing: 30
                RadioButton {
                    id: existingDevice
                    text: "Existing Device"
                }
                RadioButton {
                    id: newDevice
                    text: "New Device"
                }
            }

        }


    }
    ScrollBar {
        flickable: button_flick
        vertical: true
    }
}
