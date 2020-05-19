import QtQuick 2.3
import QtQuick.Controls 1.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.1
import "../../imports"

SplitView {
    id: profileView
    x: 0
    y: 0
    Layout.fillHeight: true
    Layout.fillWidth: true
    // Those anchors show a warning too, but whithout them, there is a gap on the right
    anchors.right: parent.right
    anchors.rightMargin: 0
    anchors.left: parent.left
    anchors.leftMargin: 0

    Item {
        id: profileColumn
        width: 300
        height: parent.height
        Layout.minimumWidth: 200

        TabBar {
            id: profileSideBar

            TabButton {
                text: "hello"
            }

            TabButton {
                text: "hello2"
            }
        }

    }

    StackLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        currentIndex: profileSideBar.currentIndex

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            TextField {
                id: menu1
                x: 19
                y: 41
                placeholderText: qsTr("Enter ETH")
                anchors.leftMargin: 24
                anchors.topMargin: 32
                width: 239
                height: 40
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            TextField {
                id: menu2
                x: 19
                y: 41
                placeholderText: qsTr("Enter SNT")
                anchors.leftMargin: 24
                anchors.topMargin: 32
                width: 239
                height: 40
            }
        }
    }

}
/*##^##
Designer {
    D{i:0;formeditorZoom:0.75;height:770;width:1152}
}
##^##*/
