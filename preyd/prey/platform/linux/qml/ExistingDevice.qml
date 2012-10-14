import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1

Page {
    id: existingDevice
    anchors.fill: parent
    orientationLock : PageOrientation.LockLandscape

    property string nextPage: ""
    property alias deviceIndex: deviceColumn.selectedIndex


    //function to apply Existing device settings
    function apply()
    {
        main.apply_device_settings(deviceIndex)
    }

    Header {
        id: my_header
        anchors{top:parent.top; right:parent.right; left:parent.left}
        info: "Please select the existing device configured in your Configuration Panel corresponding to this machine."
    }

    Row {
        id: row1
        spacing: 30
        anchors {
            left: parent.left
            top: my_header.bottom
            leftMargin: 20
        }

        Label {
            text:"Device"
            anchors.verticalCenter: device_bt.verticalCenter
        }
        TumblerButton {
            id: device_bt
            width: 300
            onClicked: selectDevice()
        }
    }
    ListModel {
        id: deviceList
        objectName: "deviceList"
        function add(val)
        {
            deviceList.append({"value": val})
        }
    }

    function selectDevice() {
        dDialog.open();
    }

    TumblerDialog {
        id: dDialog
        titleText: "Select Device"
        acceptButtonText: "Ok"
        rejectButtonText: "Cancel"
        columns: [ deviceColumn ]
        onAccepted: {device_bt.text = deviceList.get(deviceIndex).value}
    }

    TumblerColumn {
        id: deviceColumn
        items: deviceList
        label: "Device"
        selectedIndex: 0
    }

    Component.onCompleted: {
        //add devices to deviceList model and deviceIndex
        deviceIndex = main.create_device_list()
        device_bt.text = deviceList.get(deviceIndex).value
    }

}
