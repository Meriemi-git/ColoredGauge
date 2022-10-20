/*
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.9 
import QtQuick.Layouts 1.1 

import org.kde.kirigami 2.8 as Kirigami

import org.kde.ksysguard.sensors 1.0 as Sensors
import org.kde.ksysguard.faces 1.0 as Faces

import org.kde.quickcharts 1.0 as Charts
import org.kde.quickcharts.controls 1.0 as ChartControls
import org.kde.plasma.core 2.0 as PlasmaCore

Faces.SensorFace {
    id: root
    readonly property bool showSensorTitle : controller.faceConfiguration.showSensorTitle
    readonly property bool  colorizedSensorTitle : controller.faceConfiguration.colorizedSensorTitle
    readonly property real rangeFrom: root.controller.faceConfiguration.rangeFrom *
                                        root.controller.faceConfiguration.rangeFromMultiplier
    readonly property real rangeTo: root.controller.faceConfiguration.rangeTo *
                                        root.controller.faceConfiguration.rangeToMultiplier
    readonly property color coldColor: root.controller.faceConfiguration.coldColor  
    readonly property color hotColor: root.controller.faceConfiguration.hotColor 

    readonly property string no_temp_icon: "../images/no_temp.svg"
    readonly property string temp_cold_icon: "../images/temp_cold.svg"
    readonly property string temp_low_icon: "../images/temp_low.svg"
    readonly property string temp_half_icon: "../images/temp_half.svg"
    readonly property string temp_high_icon: "../images/temp_high.svg"
    readonly property string temp_hot_icon: "../images/temp_hot.svg"

    property double previousSensorValue
    property color actualColor : Qt.rgba(0,0,0,1)
    contentItem: ColumnLayout  {

        Kirigami.Heading {
            id: heading
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            text: root.controller.title
            visible: showSensorTitle && text.length > 0 
            level: 2
            color : root.actualColor
        }
        TempSensorFull {
            id : tempSensorFull
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            actualColor : root.actualColor
            sensorValue : 0.0
            sensorIcon : Qt.resolvedUrl(root.no_temp_icon)
        }

        ColorUtils.Gradien {
            id : gradien
        }

        Sensors.Sensor {
            id: sensor
            sensorId: root.controller.totalSensors.length > 0 ? root.controller.totalSensors[0] : ""
            updateRateLimit: 1000
        }

        ChartControls.PieChartControl {
            id: chart
            visible: false
            property alias sensors: sensorsModel.sensors
            property alias sensorsModel: sensorsModel
            valueSources: Charts.ModelSource {
                model: Sensors.SensorDataModel {
                    id: sensorsModel
                    sensors: root.controller.highPrioritySensorIds
                }
                roleName: "Value"
                indexColumns: true
            } 
            chart.onDataChanged:{
                const sensorValue = sensor.value
                if(sensorValue != null && previousSensorValue != sensorValue){
                    console.log('sensorValue',sensorValue)
                    if(sensorValue > root.rangeFrom && sensorValue < root.rangeTo){
                        var mix = (sensorValue- root.rangeFrom) / (root.rangeTo - root.rangeFrom)
                    }else if(sensorValue >= chart.rangeTo){
                        // Temp overshoot max
                        mix = 1
                        tempSensorFull.sensorIcon=Qt.resolvedUrl(root.temp_hot_icon)
                    }else{
                        // Temp is lower than min
                        mix = 0
                        tempSensorFull.sensorIcon=Qt.resolvedUrl(root.temp_cold_icon)
                    }  
                    // Manage intermediate temp icon
                    if(mix > 0 && mix <= 0.33){
                        tempSensorFull.sensorIcon=Qt.resolvedUrl(root.temp_low_icon)
                    }
                    if(mix > 0.33 && mix <= 0.66){
                        tempSensorFull.sensorIcon=Qt.resolvedUrl(root.temp_half_icon)
                    }
                    if(mix > 0.66 && mix < 1){
                        tempSensorFull.sensorIcon=Qt.resolvedUrl(root.temp_high_icon)
                    }
                    var newColor = gradien.generateGradient(root.coldColor,root.hotColor,mix)
                    root.actualColor = newColor
                    tempSensorFull.sensorValue = sensorValue
                    heading.color = newColor
                    previousSensorValue = sensorValue
                }
            }           
         }
    }   
}