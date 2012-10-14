import QtQuick 1.1
import com.nokia.meego 1.1

Page {
    id: reportOptions
    anchors.fill: parent
    orientationLock : PageOrientation.LockLandscape

    property string nextPage: cntrlPanel.checked ? "ControlPanel" : "StandAlone"

    //function to goto next page
    function next()
    {
        if(cntrlPanel.checked && (vars.api_key != ''))
            confirmMsg.open()
        else
            appWindow.nxtPage()
    }



    Header {
        id: my_header
        anchors{top:parent.top; right:parent.right; left:parent.left}
        info: "Please choose the reporting method for Prey. If you're not sure what you're doing, please visit preyproject.com."
    }
    ButtonColumn {
        anchors{
            bottom:parent.bottom; top:my_header.bottom;
            right:parent.right; left:parent.left
            margins:20
        }
        spacing: 20
        Row {
            property alias checked: cntrlPanel.checked
            spacing: 10
            Image {
                source:"/opt/prey/pixmaps/conf/controlpanel.png"
                anchors.verticalCenter: cntrlPanel.verticalCenter
            }
            RadioButton {
                id:cntrlPanel
                text: "Prey + Control Panel (Recommended)"
                style: RadioButtonStyle{}
            }
        }
        Row {
            property alias checked: standAlone.checked
            spacing: 10
            Image {
                source:"/opt/prey/pixmaps/conf/email.png"
                anchors.verticalCenter: standAlone.verticalCenter
            }
            RadioButton {
                id:standAlone
                text: "Prey Standalone (Advanced)"
                style: RadioButtonStyle{}
            }
        }
    }


    QueryDialog {
        id: confirmMsg
        icon: "image://theme/icon-l-error"
        titleText: "Hold your horses!"
        message: "Your device seems to be already synchronized with the Control Panel! Do you want to re-setup your account? (Not recommended)"
        acceptButtonText: "Yes"
        rejectButtonText: "No"
        onAccepted: appWindow.nxtPage()
    }

}
