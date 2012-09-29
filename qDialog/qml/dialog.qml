import QtQuick 1.1
import com.nokia.meego 1.1

PageStackWindow {
    id: appWindow

    initialPage: mainPage
    //property variant msg: alert_message //"Press accept or reject button"
    //property int trialNo: 100

    Page {
        id: mainPage
        QueryDialog {  
            id: queryDialog  
            icon: "image://theme/icon-l-error"  
            titleText: "Prey Security Alert - Stolen Mobile"  
            message: alert_message //"Press accept or reject button"  
            acceptButtonText: "Accept"  
            //rejectButtonText: "Reject"  
            onAccepted: Qt.quit()// some functionality 
            //onRejected: // some functionality   
            Component.onCompleted:queryDialog.open()
        }
    }
}
