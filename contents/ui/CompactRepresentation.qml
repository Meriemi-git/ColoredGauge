/*
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 6.6
import QtQuick.Controls 6.6 as QQC2
import QtQuick.Layouts 6.6
import org.kde.kirigami as Kirigami
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.faces as Faces
import org.kde.ksysguard.sensors as Sensors
import org.kde.plasma.core as PlasmaCore

Representation {
    id: sensorFace

    Layout.minimumHeight: parent.height

    MouseArea {
        anchors.fill: parent
        z: 100
    }

    contentItem: Item {
        Layout.minimumWidth: sensorFace.minimumWidgetWith > 0 ? sensorFace.minimumWidgetWith : iconWidget.implicitWidth
        Layout.minimumHeight: parent.height

        IconWidget {
            id: iconWidget

            actualColor: sensorFace.actualColor
            title: sensorFace.controller.title
            showValue: sensorFace.showValue
            showIcon: sensorFace.showIcon
            showUnit: sensorFace.showUnit
            decimals: sensorFace.decimals
            showTitle: sensorFace.showTitle
            svgFrames: sensorFace.svgFrames
            textOnSide: sensorFace.textOnSide
            colorized: sensorFace.colorized
            symbol: sensorFace.actualSymbol
            value: sensorFace.actualValue
            titleTopMargin: sensorFace.titleTopMargin
            titleRightMargin: sensorFace.titleRightMargin
            titleBottomMargin: sensorFace.titleBottomMargin
            titleLeftMargin: sensorFace.titleLeftMargin
            titleSize: sensorFace.titleSize
            valueTopPadding: sensorFace.valueTopPadding
            valueRightPadding: sensorFace.valueRightPadding
            valueBottomPadding: sensorFace.valueBottomPadding
            valueLeftPadding: sensorFace.valueLeftPadding
            valueSize: sensorFace.valueSize
            actualFramePath: sensorFace.actualFramePath
            backgroundColor: sensorFace.backgroundColor
            backgroundOpacity: sensorFace.backgroundOpacity

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

        }

    }

}
