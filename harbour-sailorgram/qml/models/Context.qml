import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.DBus 1.0
import harbour.sailorgram.SailorGram 1.0
import harbour.sailorgram.Model 1.0
import harbour.sailorgram.TelegramQml 1.0
import "../js/Settings.js" as Settings
import "../js/TelegramHelper.js" as TelegramHelper
import "../js/TextElaborator.js" as TextElaborator

QtObject
{
    id: context

    readonly property string hereAppId: "MqR7KyY6dZpTbKiFwc3h"
    readonly property string hereAppCode: "zfYp6V9Ou_wDQn4NVqMofA"
    readonly property string version: "0.80"
    readonly property bool beta: false
    readonly property int betanum: 1
    readonly property int stepcount: 25

    readonly property int bubbleradius: {
        if(context.angledbubbles)
            return 20;

        if(!context.bubbleshidden)
            return 4;

        return 0;
    }

    property bool sendwithreturn: false
    property bool backgrounddisabled: false
    property bool chatheaderhidden: false
    property bool bubbleshidden: false
    property bool angledbubbles: false
    property bool immediateopen: false
    property bool autoloadimages:false
    property bool showsearchfield: false
    property int bubblesopacity: 100

    function versionString() {
        var ver = context.version;

        if(beta)
            ver += " BETA " + betanum;

        return ver;
    }

    function locationThumbnail(latitude, longitude, width, height, z) {
        return "https://maps.nlp.nokia.com/mia/1.6/mapview?" + "app_id=" + hereAppId + "&"
                                                             + "app_code=" + hereAppCode + "&"
                                                             + "nord&f=0&poithm=1&poilbl=0&"
                                                             + "ctr=" + latitude + "," + longitude + "&"
                                                             + "w=" + width + "&h=" + height + "&z=" + z;
    }

    property Page mainPage: null
    property Document currentSticker: null
    property ScreenBlank screenblank: ScreenBlank { }
    property ErrorsModel errors: ErrorsModel { }
    property StickersModel stickers: StickersModel { }
    property SailorgramContactsModel contacts: SailorgramContactsModel { }
    property DialogsModel dialogs: DialogsModel { }

    property SailorGram sailorgram: SailorGram {
        telegram: context.telegram

        onConnectedChanged: {
            if(!context.sailorgram.connected)
                return;

            // Update dialogs
            context.dialogs.recheck();
        }
    }

    property Telegram telegram: Telegram {
        defaultHostAddress: "149.154.167.50"
        defaultHostDcId: 2
        defaultHostPort: 443
        appId: 27782
        appHash: "5ce096f34c8afab871edce728e6d64c9"
        configPath: sailorgram.configPath
        publicKeyFile: sailorgram.publicKey
        globalMute: false
        autoCleanUpMessages: true
        autoAcceptEncrypted: true

        onErrorSignal: errors.addError(errorCode, functionName, errorText)

        onDocumentStickerRecieved: {
            if(document !== context.currentSticker)
                return

            context.telegram.installStickerSet(set.shortName);
            context.currentSticker = null;
        }

        onIncomingMessage: {
            var elaboratedtext = TextElaborator.elaborateNotify(TelegramHelper.messageContent(context, msg), sailorgram.emojiPath, Theme.fontSizeSmall);
            var user = context.telegram.user(msg.fromId);

            sailorgram.notify(msg, TelegramHelper.completeName(user), elaboratedtext);
        }

        onPhoneNumberChanged: {
            var phonenumber = Settings.get("phonenumber");

            if(phonenumber !== false)
                return;

            Settings.set("phonenumber", context.telegram.phoneNumber); // Save Phone Number for fast login
        }

        onAuthSignInErrorChanged: {
            if(!context.telegram.authSignInError)
                return;

            pageStack.completeAnimation();
            pageStack.replace(Qt.resolvedUrl("../pages/login/AuthorizationPage.qml"), { "context": context, "authError": context.telegram.authSignInError });
        }

        onAuthSignUpErrorChanged: {
            if(!context.telegram.authSignUpError)
                return;

            pageStack.completeAnimation();
            pageStack.replace(Qt.resolvedUrl("../pages/login/SignUpPage.qml"), { "context": context, "authError": context.telegram.authSignUpError });

        }

        onAuthLoggedInChanged: {
            if(!context.telegram.authLoggedIn)
                return;

            context.telegram.online = true;

            pageStack.completeAnimation();
            pageStack.replace(Qt.resolvedUrl("../pages/dialogs/DialogsPage.qml"), { "context": context });
        }

        onAuthCodeRequested: {
            if(pageStack.currentPage.authorizationPage === true)
                return;

            pageStack.completeAnimation();

            if(context.telegram.authPhoneRegistered)
                pageStack.replace(Qt.resolvedUrl("../pages/login/AuthorizationPage.qml"), { "context": context, "authError": context.telegram.authSignInError });
            else
                pageStack.replace(Qt.resolvedUrl("../pages/login/SignUpPage.qml"), { "context": context, "authError": context.telegram.authSignUpError });
        }
    }
}
