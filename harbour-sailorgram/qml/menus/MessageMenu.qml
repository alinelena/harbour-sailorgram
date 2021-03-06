import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.TelegramQml 1.0
import "../models"
import "../items/message/messageitem/media"
import "../js/TelegramHelper.js" as TelegramHelper
import "../js/TelegramConstants.js" as TelegramConstants

ContextMenu
{
    signal replyRequested()
    signal forwardRequested()
    signal downloadRequested()
    signal cancelRequested()

    property Context context
    property Message message
    property MessageMediaItem messageMediaItem

    MenuItem
    {
        text: qsTr("Add to Telegram")
        visible: {
            var media = message.media;
            var userid = media.userId;
            return media.classType === TelegramConstants.typeMessageMediaContact &&
                   userid > 0 && !context.sailorgram.hasContact(userid);
        }
        onClicked: {
            var media = message.media;
            pageStack.push(Qt.resolvedUrl("../pages/contacts/AddContactPage.qml"), {
                               "context": context,
                               "firstname": media.firstName,
                               "lastname": media.lastName,
                               "telephonenumber": media.phoneNumber
                           });
        }
    }

    MenuItem
    {
        text: qsTr("Reply")
        visible: message.classType !== TelegramConstants.typeMessageService
        onClicked: replyRequested();
    }

    MenuItem
    {
        text: qsTr("Forward")
        visible: message.classType !== TelegramConstants.typeMessageService
        onClicked: forwardRequested();
    }

    MenuItem
    {
        text: qsTr("Copy")
        visible: !message.media || (message.media.classType === TelegramConstants.typeMessageMediaEmpty)

        onClicked: {
            Clipboard.text = message.message;
            popupmessage.show(qsTr("Message copied to clipboard"));
        }
    }

    MenuItem
    {
        text: qsTr("Delete")

        onClicked: {
            messageitem.remorseAction(qsTr("Deleting Message"), function() {
                context.telegram.deleteMessages([message.id]);
            });
        }
    }

    MenuItem
    {
        text: qsTr("Install Sticker set")
        visible: TelegramHelper.isSticker(context, message)

        onClicked: {
            context.currentSticker = message.media.document;
            context.telegram.getStickerSet(message.media.document);
        }
    }

    MenuItem
    {
        text: {
            if(TelegramHelper.isMediaMessage(message) && messageMediaItem && !messageMediaItem.transferInProgress)
                return messageMediaItem.fileHandler.downloaded ? qsTr("Open") : qsTr("Download");

            return "";
        }

        visible: text.length > 0

        onClicked: {
            messageitem.remorseAction(qsTr("Downloading media"), function() {
                downloadRequested();
            });
        }
    }

    MenuItem
    {
        text: qsTr("Cancel")
        visible: messageMediaItem && !messageMediaItem.isUpload && messageMediaItem.transferInProgress
        onClicked: cancelRequested()
    }
}
