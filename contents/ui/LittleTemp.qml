/*
    SPDX-License-Identifier: LGPL-2.0-or-later
*/
import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2 as QQC2

import QtGraphicalEffects 1.12

import org.kde.ksysguard.sensors 1.0 as Sensors
import org.kde.ksysguard.faces 1.0 as Faces
import org.kde.quickcharts 1.0 as Charts
import org.kde.quickcharts.controls 1.0 as ChartControls
import org.kde.plasma.core 2.0 as PlasmaCore

TempSensor {
    Row  {
        Column {
            QQC2.Label {
                id: title
                visible: showSensorTitle
                text: root.controller.title
                color : actualColor
                fontSizeMode : Text.Fit
            }

            QQC2.Label {
                id: label
                visible: showText
                text: roundedValue ? Math.round(sensorValue) + "°C" : sensorValue.toFixed(2)+ "°C"
                color : actualColor
                font.bold: true
                fontSizeMode : Text.Fit
                anchors{
                    right : parent.right
                    rightMargin : 2
                }
            }
        }
        PlasmaCore.Svg {
            id: iconSvg
            imagePath: getImagePathFromValue(mix)
            property real ratio : 1.84
        } 

        PlasmaCore.SvgItem {
            id: svgItem
            visible: showIcon
            svg: iconSvg
            height : parent.height
            width : height / iconSvg.ratio
            anchors{
                top : parent.top
                bottom : parent.bottom
            }
            layer.enabled: true
            layer.effect: ColorOverlay{
                id: overlay
                source:svgItem
                color: actualColor
                antialiasing: true
            }
        }  
    }     
}
