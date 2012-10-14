import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1

Page {
    id: standAlone
    anchors.fill: parent
    orientationLock : PageOrientation.LockLandscape

    property string nextPage: ""

    //function to apply StandAlone settings
    function apply()
    {
        vars.check_url = my_url.text
        vars.mail_to = my_email.text
        vars.smtp_username = my_user.text
        vars.smtp_server = my_server.text
        main.apply_standalone_settings(my_passwd.text)
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
            info: "Please configure your SMTP settings. You also need to generate the URL that when deleted will trigger Prey, otherwise you'll start receiving reports immediately."
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
                id: my_url
                width: 400
                label: "Check URL"
                text:vars.check_url
            }
            TextEntry {
                id: my_email
                width: 400
                label: "Email"
                text:vars.mail_to
            }
            TextEntry {
                id: my_user
                width: 400
                label: "SMTP User"
                text:vars.smtp_username
            }
            TextEntry {
                id: my_server
                width: 400
                label: "SMTP Server"
                text:vars.smtp_server
            }
            TextEntry {
                id: my_passwd
                width: 400
                label: "SMTP Pass"
                echoMode: TextInput.Password
            }

        }


    }
    ScrollBar {
        flickable: button_flick
        vertical: true
    }
}
