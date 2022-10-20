/*
    SPDX-License-Identifier: LGPL-2.0-or-later
*/
import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2 as QQC2

import QtGraphicalEffects 1.12

import org.kde.ksysguard.sensors 1.0 as Sensors
import org.kde.ksysguard.faces 1.0 as Faces
import org.kde.kirigami 2.11 as Kirigami

import org.kde.quickcharts 1.0 as Charts
import org.kde.quickcharts.controls 1.0 as ChartControls
import org.kde.plasma.core 2.0 as PlasmaCore

TempSensor
{
        id: bigTemp
        Layout.fillHeight: true 
        Layout.fillWidth: true
        Layout.alignment : Qt.AlignHCenter | Qt.AlignTop

        Item {
            id: iconTemp
            visible: showIcon
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment : Qt.AlignHCenter | Qt.AlignTop

            PlasmaCore.Svg {
                id: iconSvg
                imagePath: {
                    if(mix == 1.0){
                        // Temp overshoot max
                        return Qt.resolvedUrl(bigTemp.temp_hot_icon)
                    }
                    if (mix == 0.){
                        // Temp is lower than min
                        return Qt.resolvedUrl(bigTemp.temp_cold_icon)
                    }  
                    // Manage intermediate temp icon
                    if(mix > 0 && mix <= 0.33){
                        return Qt.resolvedUrl(bigTemp.temp_low_icon)
                    }
                    if(mix > 0.33 && mix <= 0.66){
                        return Qt.resolvedUrl(bigTemp.temp_half_icon)
                    }
                    if(mix > 0.66 && mix < 1){
                        return Qt.resolvedUrl(bigTemp.temp_high_icon)
                    }
                }
                property double ratio : 1.84
            }

            PlasmaCore.SvgItem {
                id: svgItem
                visible: false
                anchors.horizontalCenter: parent.horizontalCenter 
                width: height / iconSvg.ratio
                height: iconTemp.height
                svg: iconSvg
            }

            ColorOverlay{
                id: overlay
                anchors.fill: svgItem
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment : Qt.AlignHCenter | Qt.AlignTop
                source:svgItem
                color: bigTemp.actualColor
                antialiasing: true
                visible : sensorValue > 0.0
            }

            QQC2.Label {
                id: iconLabel
                visible: showText
                color: "black"
                z:1
                horizontalAlignment: Text.AlignHCenter
                text: bigTemp.roundedValue ? Math.round(sensorValue) + "°C" : sensorValue.toFixed(2)+ "°C"
                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2
                anchors.horizontalCenter: parent.horizontalCenter  
                antialiasing : true        
                anchors {
                    bottom: iconTemp.bottom
                    bottomMargin: iconTemp.height * 0.15
                }
                font.bold: true
                layer.enabled: true
                layer.effect: Glow {
                    radius: 4
                    samples: 17
                    color: bigTemp.actualColor 
                    source: iconLabel
                    spread: 0.5
                }
            }     
        }

        QQC2.Label {
            id: label
            visible: showText && !showIcon
            color: "black"
            z:1
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: bigTemp.roundedValue ? Math.round(sensorValue) + "°C" : sensorValue.toFixed(2)+ "°C"
            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2
            antialiasing : true        
            font.bold: true
            layer.enabled: true
            layer.effect: Glow {
                radius: 4
                samples: 17
                color: bigTemp.actualColor 
                source: label
                spread: 0.5
            }
        } 
    }
