import QtQuick 2.13
import QtQuick.Layouts 1.13
import "../../../../imports"
import "../../../../shared"
import "../../../../shared/status"

Item {
    id: root
    Layout.fillHeight: true
    Layout.fillWidth: true

    Column {
        id: containerColumn
        spacing: Style.current.padding
        anchors.top: parent.top
        anchors.topMargin: Style.current.padding
        anchors.right: parent.right
        anchors.rightMargin: contentMargin
        anchors.left: parent.left
        anchors.leftMargin: contentMargin
        anchors.bottom: parent.bottom

        StatusSectionHeadline {
            id: labelGeneral
            text: qsTr("General")
        }

        StatusSettingsLineButton {
            text: qsTr("Show favorites bar")
            isSwitch: true
            switchChecked: appSettings.showFavoritesBar
            onClicked: function (checked) {
                appSettings.showFavoritesBar = checked
            }
        }

        RowLayout {
            StyledText {
                text: qsTr("Autoload images")
            }
            StatusSwitch {
                checked: appSettings.autoLoadImages
                onCheckedChanged: function() {
                    appSettings.autoLoadImages = this.checked
                }
            }
        }

        RowLayout {
            StyledText {
                text: qsTr("JavaScript On")
            }
            StatusSwitch {
                checked: appSettings.javaScriptEnabled
                onCheckedChanged: function() {
                    appSettings.javaScriptEnabled = this.checked
                }
            }
        }

        RowLayout {
            StyledText {
                text: qsTr("Error Page On")
            }
            StatusSwitch {
                checked: appSettings.errorPageEnabled
                onCheckedChanged: function() {
                    appSettings.errorPageEnabled = this.checked
                }
            }
        }

        RowLayout {
            StyledText {
                text: qsTr("Plugins On")
            }
            StatusSwitch {
                checked: appSettings.pluginsEnabled
                onCheckedChanged: function() {
                    appSettings.pluginsEnabled = this.checked
                }
            }
        }

        RowLayout {
            StyledText {
                text: qsTr("Icons On")
            }
            StatusSwitch {
                checked: appSettings.autoLoadIconsForPage
                onCheckedChanged: function() {
                    appSettings.autoLoadIconsForPage = this.checked
                }
            }
        }

        RowLayout {
            StyledText {
                text: qsTr("Touch Icons On")
            }
            StatusSwitch {
                checked: appSettings.touchIconsEnabled
                onCheckedChanged: function() {
                    appSettings.touchIconsEnabled = this.checked
                }
            }
        }

        RowLayout {
            StyledText {
                text: qsTr("WebRTC Public Interfaces Only")
            }
            StatusSwitch {
                checked: appSettings.webRTCPublicInterfacesOnly
                onCheckedChanged: function() {
                    appSettings.webRTCPublicInterfacesOnly = this.checked
                }
            }
        }

        RowLayout {
            StyledText {
                text: qsTr("PDF viewer enabled")
            }
            StatusSwitch {
                checked: appSettings.pdfViewerEnabled
                onCheckedChanged: function() {
                    appSettings.pdfViewerEnabled = this.checked
                }
            }
        }
    }

    // TODO find what to do with this one
    //        MenuItem {
    //            id: httpDiskCacheEnabled
    //            text: "HTTP Disk Cache"
    //            checkable: currentWebView && !currentWebView.profile.offTheRecord
    //            checked: currentWebView && (currentWebView.profile.httpCacheType === WebEngineProfile.DiskHttpCache)
    //            onToggled: function(checked) {
    //                if (currentWebView) {
    //                    currentWebView.profile.httpCacheType = checked ? WebEngineProfile.DiskHttpCache : WebEngineProfile.MemoryHttpCache;
    //                }
    //            }
    //        }
}

/*##^##
Designer {
    D{i:0;height:400;width:700}
}
##^##*/
