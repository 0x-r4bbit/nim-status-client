import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

import utils 1.0
import "../../../../shared"
import "../../../../shared/status"

// TODO: replace with StatusQ component
StatusRadioButtonRow {
    property string fleetName: ""
    property string newFleet: ""
    text: fleetName
    buttonGroup: fleetSettings
    checked: profileModel.fleets.fleet === text
    onRadioCheckedChanged: {
        if (checked) {
            if (profileModel.fleets.fleet === fleetName) return;
            newFleet = fleetName;
            openPopup(confirmDialogComponent)
        }
    }

    Component {
        id: confirmDialogComponent
        ConfirmationDialog {
            //% "Warning!"
            header.title: qsTrId("close-app-title")
            //% "Change fleet to %1"
            confirmationText: qsTrId("change-fleet-to--1").arg(newFleet)
            onConfirmButtonClicked: profileModel.fleets.setFleet(newFleet)
            onClosed: {
                profileModel.fleets.triggerFleetChange()
                destroy();
            }
        }
    }
}
