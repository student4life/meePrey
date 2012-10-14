import QtQuick 1.1
import com.nokia.meego 1.1

PageStackWindow {
    id: appWindow

    property string nextPage: tab2.currentPage.nextPage
    property variant currentPage: getCrntPage()

    function getCrntPage()
    {
        if(tabGroup.currentTab == tab1)
            return tab1
        else
            return tab2.currentPage
    }
    function islastPage() 
    {
        return currentPage.nextPage == ""
    }

    function nxtPage()
    {
        console.log("opening page: "+nextPage)
        tab2.push(Qt.resolvedUrl(nextPage+".qml"))
    }

    function prvPage()
    {
        tabGroup.currentTab.pop()
    }

    function show_alert(title,msg,exit)
    {
        alert.acceptButtonText = "Ok"
        alert.titleText = title
        alert.message = msg
        alert.exit = exit
        alert.open()
    }

    initialPage: mainPage
    showStatusBar: false

    Page {
        id: mainPage
        orientationLock : PageOrientation.LockLandscape
        tools: commonTools

        TabGroup {
             id: tabGroup
             currentTab: tab1
             MainSettings {
                 id: tab1
                 anchors.fill: parent
             }
             PageStack {
                 id: tab2
                 anchors.fill: parent
             }
        }
    }
    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon { id:exit_B; iconId: "toolbar-close"; onClicked: Qt.quit(); }
        ButtonRow {
            id: my_tabs
            style: TabButtonStyle { }
            TabButton {
                text: "Main Settings"
                tab: tab1
            }
            TabButton {
                text: "Reporting Mode"
                tab: tab2
            }
        }
        ToolIcon {
            id: prv_B
            platformIconId: "toolbar-tab-previous"
            anchors.verticalCenter: exit_B.verticalCenter
            visible: tabGroup.currentTab.depth > 1
            onClicked: prvPage()
        }
        ToolIcon {
            id: nxt_B
            platformIconId: "toolbar-tab-next"
            anchors.verticalCenter: exit_B.verticalCenter
            onClicked: currentPage.next()
            visible: !islastPage()
        }
        ToolIcon {
            id: apply_B
            platformIconId: "toolbar-done"
            anchors.verticalCenter: exit_B.verticalCenter
            onClicked: currentPage.apply()
            visible: islastPage()
        }
    }
    Component.onCompleted: {tab2.push(Qt.resolvedUrl("ReportOptions.qml"))}

    QueryDialog {
        id: alert
        property bool exit: false
        icon: "image://theme/icon-l-error"
        onAccepted: if(exit) {Qt.quit()}
    }

}
