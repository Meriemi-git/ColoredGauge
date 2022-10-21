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
    formFactor : FormFactor.Constrained

    readonly property bool showLegend : controller.faceConfiguration.showLegend
    readonly property bool showSensorTitle : controller.faceConfiguration.showSensorTitle
    readonly property bool levelMode : controller.faceConfiguration.levelMode
    readonly property bool colorizedSensorTitle : controller.faceConfiguration.colorizedSensorTitle
    readonly property bool forceCompact: controller.faceConfiguration.forceCompact
    readonly property real rangeFrom: root.controller.faceConfiguration.rangeFrom *
                                        root.controller.faceConfiguration.rangeFromMultiplier
    readonly property real rangeTo: root.controller.faceConfiguration.rangeTo *
                                        root.controller.faceConfiguration.rangeToMultiplier
    readonly property color coldColor: root.controller.faceConfiguration.coldColor  
    readonly property color hotColor: root.controller.faceConfiguration.hotColor 

    property alias headingSensor: sensor.sensorId
    property alias sensors: sensorsModel.sensors
    property alias sensorsModel: sensorsModel

    property double previousSensorValue
    property color actualColor : Qt.rgba(1,1,1,1)
    property double sensorValue : 0.0
    property double mix : 0.0 

    ColorUtils.Gradien {
        id : gradien
    }

    Sensors.Sensor {
        id: sensor
        sensorId: root.controller.totalSensors.length > 0 ? root.controller.totalSensors[0] : ""
        updateRateLimit: 1000
    }

    Charts.PieChart {
        id: chart
        visible: false
        property alias sensors: sensorsModel.sensors
        property alias sensorsModel: sensorsModel
        valueSources: Charts.ModelSource {
            model: Sensors.SensorDataModel {
                id: sensorsModel
                sensors: root.controller.highPrioritySensorIds
                updateRateLimit: chart.updateRateLimit
                sensorLabels: root.controller.sensorLabels
            }
            roleName: "Value"
            indexColumns: true
        }
        onDataChanged:{
            const sensorValue = sensor.value
            if(sensorValue != null && previousSensorValue != sensorValue){
                if(sensorValue > root.rangeFrom && sensorValue < root.rangeTo){
                    var mix = (sensorValue- root.rangeFrom) / (root.rangeTo - root.rangeFrom)
                }else if(sensorValue >= root.rangeTo){
                    // Temp overshoot max
                    mix = 1
                }else if(sensorValue <= root.rangeFrom){
                    // Temp is lower than min
                    mix = 0
                }  
                var newColor = gradien.generateGradient(root.coldColor,root.hotColor,mix)
                root.actualColor = newColor
                root.sensorValue = sensorValue
                root.mix = mix
                previousSensorValue = sensorValue
            }
        }           
    }
}