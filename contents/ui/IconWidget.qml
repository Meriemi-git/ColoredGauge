import Qt5Compat.GraphicalEffects
/*
    SPDX-License-Identifier: LGPL-2.0-or-later
*/
import QtQuick 6.6
import QtQuick.Controls 6.6 as QQC2
import QtQuick.Layouts 6.6
import org.kde.kirigami as Kirigami
import org.kde.ksvg 1.0 as KSvg
import org.kde.ksysguard.faces as Faces
import org.kde.ksysguard.sensors as Sensors
import org.kde.plasma.plasmoid as Plasmoid

ColumnLayout {
    id: iconWidget

    property bool showValue
    property bool showIcon
    property bool showUnit
    property bool showTitle
    property bool colorized
    property bool textOnSide
    property int decimals
    property int titleTopMargin
    property int titleRightMargin
    property int titleBottomMargin
    property int titleLeftMargin
    property int titleSize
    property int valueTopPadding
    property int valueRightPadding
    property int valueBottomPadding
    property int valueLeftPadding
    property color backgroundColor
    property real backgroundOpacity
    property int valueSize
    property var svgFrames
    property color actualColor
    property string title
    property string symbol
    property string value
    property string actualFramePath
    property color defaultColor: "white"

    Layout.minimumHeight: parent.height
    Layout.rightMargin: 10
    Layout.leftMargin: 10
    height: parent.height

    RowLayout {
        spacing: 2
        Layout.minimumHeight: iconWidget.height
        Layout.minimumWidth: iconWidget.height

        ColumnLayout {
            id: columnLayout

            visible: textOnSide
            Layout.minimumHeight: iconWidget.height
            spacing: 0

            QQC2.Label {
                id: titleLabelSide

                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                Layout.topMargin: iconWidget.titleTopMargin
                Layout.rightMargin: iconWidget.titleRightMargin
                Layout.bottomMargin: iconWidget.titleBottomMargin
                Layout.leftMargin: iconWidget.titleLeftMargin
                visible: showTitle
                text: title
                color: colorized ? actualColor : defaultColor
                font.bold: true
                font.pixelSize: iconWidget.titleSize
                layer.enabled: true
                rightInset: -3
                leftInset: -3

                background: Rectangle {
                    color: Qt.hsla(iconWidget.backgroundColor.hslHue, iconWidget.backgroundColor.hslSaturation, iconWidget.backgroundColor.hslLightness, iconWidget.backgroundOpacity)
                    radius: Math.min(titleLabelSide.width, titleLabelSide.height) * 0.4999
                }

                layer.effect: Glow {
                    id: valueLabelSide

                    radius: 4
                    samples: 17
                    color: "black"
                    spread: 0.5
                }

            }

            QQC2.Label {
                id: valueLabelSide

                Layout.alignment: Qt.AlignHCenter | Qt.AlignDown
                Layout.topMargin: iconWidget.valueTopPadding
                Layout.rightMargin: iconWidget.valueRightPadding
                Layout.bottomMargin: iconWidget.valueBottomPadding
                Layout.leftMargin: iconWidget.valueLeftPadding
                visible: showValue
                text: value + " " + (showUnit ? symbol : "")
                color: colorized ? actualColor : defaultColor
                font.bold: true
                font.pixelSize: iconWidget.valueSize
                layer.enabled: true
                rightInset: -3
                leftInset: -3

                background: Rectangle {
                    color: Qt.hsla(iconWidget.backgroundColor.hslHue, iconWidget.backgroundColor.hslSaturation, iconWidget.backgroundColor.hslLightness, iconWidget.backgroundOpacity)
                    radius: Math.min(valueLabelSide.width, valueLabelSide.height) * 0.4999
                }

                layer.effect: Glow {
                    radius: 4
                    samples: 17
                    color: "black"
                    spread: 0.5
                }

            }

        }

        Rectangle {
            id: svgContainer

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            color: "#00FFFFFF"
            width: textOnSide ? svgItem.width : Math.max(svgItem.width, columnLayoutHover.width)
            height: svgItem.height
            Layout.minimumHeight: iconWidget.height
            Layout.minimumWidth: textOnSide ? svgItem.width : Math.max(svgItem.width, columnLayoutHover.width)

            KSvg.SvgItem {
                id: svgItem

                z: 1
                visible: showIcon
                svg: iconSvg
                height: iconWidget.height
                width: (iconWidget.height / svgItem.naturalSize.height) * svgItem.naturalSize.width
                layer.enabled: true

                KSvg.Svg {
                    id: iconSvg

                    usingRenderingCache: false
                    imagePath: actualFramePath
                }

                anchors {
                    bottom: svgContainer.bottom
                    horizontalCenter: svgContainer.horizontalCenter
                }

                layer.effect: ColorOverlay {
                    id: overlay

                    source: svgItem
                    color: actualColor
                    antialiasing: true
                }

            }

            ColumnLayout {
                id: columnLayoutHover

                visible: !textOnSide
                z: 100
                height: iconWidget.height
                Layout.minimumHeight: iconWidget.height
                spacing: 0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignDown

                anchors {
                    horizontalCenter: svgContainer.horizontalCenter
                    bottom: svgContainer.bottom
                    top: svgContainer.top
                }

                QQC2.Label {
                    id: titleHover

                    z: 100
                    visible: showTitle
                    text: title
                    color: colorized ? actualColor : defaultColor
                    font.pixelSize: iconWidget.titleSize
                    font.bold: true
                    layer.enabled: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.topMargin: iconWidget.titleTopMargin
                    Layout.rightMargin: iconWidget.titleRightMargin
                    Layout.bottomMargin: iconWidget.titleBottomMargin
                    Layout.leftMargin: iconWidget.titleLeftMargin
                    rightInset: -3
                    leftInset: -3

                    background: Rectangle {
                        color: Qt.hsla(iconWidget.backgroundColor.hslHue, iconWidget.backgroundColor.hslSaturation, iconWidget.backgroundColor.hslLightness, iconWidget.backgroundOpacity)
                        radius: Math.min(titleHover.width, titleHover.height) * 0.4999
                    }

                    layer.effect: Glow {
                        radius: 4
                        samples: 17
                        color: "black"
                        spread: 0.5
                    }

                }

                QQC2.Label {
                    id: labelHover

                    z: 100
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignDown
                    Layout.topMargin: iconWidget.valueTopPadding
                    Layout.rightMargin: iconWidget.valueRightPadding
                    Layout.bottomMargin: iconWidget.valueBottomPadding
                    Layout.leftMargin: iconWidget.valueLeftPadding
                    visible: showValue
                    text: value + " " + (showUnit ? symbol : "")
                    color: colorized ? actualColor : defaultColor
                    font.bold: true
                    font.pixelSize: iconWidget.valueSize
                    layer.enabled: true
                    rightInset: -3
                    leftInset: -3
                    layer.smooth: true

                    background: Rectangle {
                        color: Qt.hsla(iconWidget.backgroundColor.hslHue, iconWidget.backgroundColor.hslSaturation, iconWidget.backgroundColor.hslLightness, iconWidget.backgroundOpacity)
                        radius: Math.min(labelHover.width, labelHover.height) * 0.4999
                    }

                    layer.effect: Glow {
                        radius: 4
                        samples: 17
                        color: "black"
                        spread: 0.5
                    }

                }

            }

        }

    }

}
