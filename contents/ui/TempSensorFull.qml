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

ColumnLayout {
    id: tempSensorFull
    Layout.fillHeight: true 
    Layout.fillWidth: true
    Layout.alignment : Qt.AlignHCenter | Qt.AlignTop

    readonly property bool showText : root.controller.faceConfiguration.showText
    readonly property bool showIcon : root.controller.faceConfiguration.showIcon
    readonly property bool roundedValue : root.controller.faceConfiguration.roundedValue
    property color actualColor 
    property double sensorValue
    property string sensorIcon 
    Item {
        id: iconTemp
        visible: showIcon
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.alignment : Qt.AlignHCenter | Qt.AlignTop

        PlasmaCore.Svg {
            id: iconSvg
            imagePath: sensorIcon
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
            color: tempSensorFull.actualColor
            antialiasing: true
            visible : sensorValue > 0.0
        }

        QQC2.Label {
            id: iconLabel
            visible: showText
            color: "black"
            z:1
            horizontalAlignment: Text.AlignHCenter
            text: tempSensorFull.roundedValue ? Math.round(sensorValue) + "°C" : sensorValue.toFixed(2)+ "°C"
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
                color: tempSensorFull.actualColor 
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
        text: tempSensorFull.roundedValue ? Math.round(sensorValue) + "°C" : sensorValue.toFixed(2)+ "°C"
        font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2
        antialiasing : true        
        font.bold: true
        layer.enabled: true
        layer.effect: Glow {
            radius: 4
            samples: 17
            color: tempSensorFull.actualColor 
            source: label
            spread: 0.5
        }
    } 
}
