import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1

Page {
    id: mainSettings
    anchors.fill: parent
    property string nextPage: ""


    //function to apply main settings
    function apply()
    {
        vars.auto_connect = wifi_bx.checked? 'y': 'n'
        vars.extended_headers = extnd_bx.checked? 'y': 'n'
        main.apply_main_settings(delay_bt.text)
    }

    Header {
        id: my_header
        anchors{top:parent.top; right:parent.right; left:parent.left}
        info: "For advanced settings please check the config file. Modules are set up on the Control Panel."
    }
    ButtonColumn {
        anchors{
            bottom:parent.bottom; top:my_header.bottom;
            right:parent.right; left:parent.left
            margins:20
        }
        spacing: 10
        Row {
            spacing: 10
            Image  {
                source: "/opt/prey/pixmaps/conf/delay.png"
                anchors.verticalCenter: delay_bt.verticalCenter
            }
            TumblerButton {
                id: delay_bt
                text: delayColumn.selectedIndex*5+5
                width: 120
                onClicked: selectDelay()
            }
            Label {
                text:"Frequency of reports and actions"
                anchors.verticalCenter: delay_bt.verticalCenter
            }
        }
        Row {
            spacing: 10
            Image  {
                source: "/opt/prey/pixmaps/conf/wifi.png"
                anchors.verticalCenter: wifi_bx.verticalCenter
            }
            CheckBox {
                id: wifi_bx
                text: "Wifi autoconnect"
                checked: vars.auto_connect == 'y'
                enabled: false
            }
        }
        Row {
            spacing: 10
            Image  {
                source: "/opt/prey/pixmaps/conf/system.png"
                anchors.verticalCenter: extnd_bx.verticalCenter
            }
            CheckBox {
                id: extnd_bx
                text: "Extended headers"
                checked: vars.extended_headers == 'y'
            }
        }
        //Row {
        //    spacing: 10
        //    Image  {
        //        source: "/opt/prey/pixmaps/conf/user.png"
        //        anchors.verticalCenter: guest_bx.verticalCenter
        //    }
        //    CheckBox {
        //        id: guest_bx
        //        text: "Enable guest account"
        //        enabled: false
        //    }
        //}

    }

    function selectDelay() {
        tDialog.open();
    }

    TumblerDialog {
        id: tDialog
        titleText: "Select Period (Minutes)"// of Reports and Actions"
        acceptButtonText: "Ok"
        rejectButtonText: "Cancel"
        columns: [ delayColumn ]
    }

    function initializeDataModels() {
        for (var delay = 5; delay <= 55; delay=delay+5) {
            delayList.append({"value" : delay});
        }
    }

    Component.onCompleted: {
        initializeDataModels();
    }

    TumblerColumn {
        id: delayColumn
        items: ListModel { id: delayList }
        label: "Delay"
        selectedIndex: (vars.delay/5-1)
    }

}
