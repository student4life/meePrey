import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1

Page {
    id: newUser
    anchors.fill: parent
    orientationLock : PageOrientation.LockLandscape

    property string nextPage: ""

    //function to apply New user settings
    function apply()
    {
        vars.user_name = my_name.text
        vars.email = my_email.text
        vars.password = my_password.text
        vars.password_confirm = my_CnfrmPasswd.text
        main.create_new_user()
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
            info: "Please provide the following information so we can create your account. Once it's created we'll send you an email to confirm the address you entered is correct."
        }

        Column {
            id: col1
            spacing: 30
            anchors {
                left: parent.left
                top: my_header.bottom
                leftMargin: 20
            }

            TextEntry {
                id:my_name
                width: 400
                label: "Your Name"
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
            TextEntry {
                id: my_CnfrmPasswd
                width: 400
                label: "Confirm Password"
                echoMode: TextInput.Password
            }

        }


    }
    ScrollBar {
        flickable: button_flick
        vertical: true
    }
}
