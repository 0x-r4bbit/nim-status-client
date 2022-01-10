pragma Singleton

import QtQuick 2.13
import "../../app/AppLayouts/Chat/popups"

QtObject {
    id: root

    property var applicationWindow
    property bool popupOpened: false
    property int currentMenuTab: 0
    property var errorSound: Audio {
        id: errorSound
        track: Qt.resolvedUrl("../assets/audio/error.mp3")
    }

    property var mainModuleInst: !!mainModule ? mainModule : null
    property var toastMessage
    property bool profilePopupOpened: false
    //Not refactored yet
    property bool networkGuarded: false //profileModel.network.current === Constants.networkMainnet || (profileModel.network.current === Constants.networkRopsten && localAccountSensitiveSettings.stickersEnsRopsten)

    signal openImagePopup(var image)
    signal openLinkInBrowser(string link)
    signal openChooseBrowserPopup(string link)
    signal openPopupRequested(var popupComponent, var params)
    signal openDownloadModalRequested()
    signal settingsLoaded()
    signal openBackUpSeedPopup()

    signal openProfilePopupRequested(string publicKey, var parentPopup)

    function openProfilePopup(publicKey, parentPopup){
        openProfilePopupRequested(publicKey, parentPopup);
    }

    function openPopup(popupComponent, params = {}) {
        root.openPopupRequested(popupComponent, params);
    }

    function openDownloadModal(){
        openDownloadModalRequested();
    }

    function changeAppSectionBySectionType(sectionType, profileSectionId = -1) {
        mainModuleInst.setActiveSectionBySectionType(sectionType)
        if (profileSectionId > -1) {
            currentMenuTab = profileSectionId;
        }
    }

    function getProfileImage(pubkey, isCurrentUser, useLargeImage) {
        if (isCurrentUser || (isCurrentUser === undefined && pubkey === userProfile.pubKey)) {
            return userProfile.icon;
        }

        let contactDetails = Utils.getContactDetailsAsJson(pubkey)
        if (localAccountSensitiveSettings.onlyShowContactsProfilePics && !contactDetails.isContact) {
            return;
        }

        return contactDetails.displayIcon
    }

    function openLink(link) {
        if (localAccountSensitiveSettings.showBrowserSelector) {
            openChooseBrowserPopup(link);
        } else {
            if (localAccountSensitiveSettings.openLinksInStatus) {
                changeAppSectionBySectionType(Constants.appSection.browser);
                openLinkInBrowser(link);
            } else {
                Qt.openUrlExternally(link);
            }
        }
    }

    function playErrorSound() {
        errorSound.play();
    }

    function settingsHasLoaded() {
        settingsLoaded()
    }
}