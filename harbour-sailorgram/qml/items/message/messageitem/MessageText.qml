import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.TelegramQml 1.0
import "../../../models"
import "../../../js/TelegramHelper.js" as TelegramHelper
import "../../../js/TelegramAction.js" as TelegramAction

Item
{
    property Context context
    property Message message
    property real calculatedWidth: Math.max(mtctextcontent.contentWidth, (msgstatus.width + lbldate.contentWidth))

    id: messagetext
    height: content.height

    Column
    {
        id: content
        anchors.top: parent.top
        width: parent.width
        spacing: Theme.paddingSmall

        MessageTextContent
        {
            id: mtctextcontent

            anchors {
                left: message.out ? parent.left : undefined;
                right: message.out ? undefined : parent.right;
                leftMargin: message.out ? Theme.paddingSmall : undefined
                rightMargin: message.out ? undefined : Theme.paddingSmall
            }

            width: parent.width
            font.pixelSize: TelegramHelper.isServiceMessage(message) ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall
            font.italic: TelegramHelper.isServiceMessage(message)
            horizontalAlignment: TelegramHelper.isServiceMessage(message) ? Text.AlignHCenter : (message.out ? Text.AlignLeft : Text.AlignRight)
            emojiPath: context.sailorgram.emojiPath
            rawText: TelegramHelper.isServiceMessage(message) ? TelegramAction.actionType(context.telegram, dialog, message) : messageitem.message.message
            linkColor: message.out ? Theme.secondaryHighlightColor : Theme.secondaryColor
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
            visible: text.length > 0

            color: {
                if(TelegramHelper.isServiceMessage(message))
                    return Theme.secondaryHighlightColor;

                if(message.out)
                    return Theme.highlightDimmerColor;

                return Theme.primaryColor;
            }
        }

        Row
        {
            anchors {
                right: message.out ? undefined : parent.right;
                left: message.out ? parent.left : undefined
                leftMargin: message.out ? Theme.paddingSmall : undefined
                rightMargin: message.out ? undefined : Theme.paddingSmall
            }

            Label
            {
                id: lbldate
                font.pixelSize: Theme.fontSizeTiny
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: message.out ? Text.AlignLeft : Text.AlignRight
                text: TelegramHelper.printableDate(message.date)
                visible: !TelegramHelper.isServiceMessage(message)
                width: messagetext.calculatedWidth - msgstatus.paintedWidth

                color: {
                    if(message.out || TelegramHelper.isServiceMessage(message))
                        return Theme.highlightDimmerColor;

                    return Theme.primaryColor;
                }
            }

            MessageStatus
            {
                id: msgstatus
                height: lbldate.paintedHeight
                message: messagetext.message
            }
        }
    }
}
