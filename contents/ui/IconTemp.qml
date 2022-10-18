import QtQuick 2.9
import QtGraphicalEffects 1.12

import org.kde.ksysguard.sensors 1.0 as Sensors
import org.kde.ksysguard.faces 1.0 as Faces

import org.kde.quickcharts 1.0 as Charts
import org.kde.quickcharts.controls 1.0 as ChartControls
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: iconTemp

    PlasmaCore.Svg {
        id: iconsvg
        imagePath: Qt.resolvedUrl("../images/temp.svg")
        property double ratio : 1.84
    }

    PlasmaCore.SvgItem {
        id: svgItem
        visible: false
        width: height / iconsvg.ratio
        height:  parent.height

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        svg: iconsvg
    }

    ColorOverlay{
        id: overlay
        anchors.fill: svgItem
        source:svgItem
        color: Qt.rgba(0,0,0,0)
        antialiasing: true
    }

    ChartControls.PieChartControl {
        id: chart
        visible: false
        property color coldColor
        property color hotColor
        property color newColor
        property double resultRed
        property double resultGreen 
        property double resultBlue
        property double percent
        property double previousSensorValue
        property alias sensors: sensorsModel.sensors
        property alias sensorsModel: sensorsModel

        readonly property real rangeFrom: root.controller.faceConfiguration.rangeFrom *
                                      root.controller.faceConfiguration.rangeFromMultiplier

        readonly property real rangeTo: root.controller.faceConfiguration.rangeTo *
                                    root.controller.faceConfiguration.rangeToMultiplier

        valueSources: Charts.ModelSource {
            model: Sensors.SensorDataModel {
                id: sensorsModel
                sensors: root.controller.highPrioritySensorIds
            }
            roleName: "Value"
            indexColumns: true
        } 
        chart.onDataChanged:{
            if(sensor.value != previousSensorValue){
                if(sensor.value > chart.rangeFrom && sensor.value < chart.rangeTo){
                    percent = (sensor.value - chart.rangeFrom) / (chart.rangeTo - chart.rangeFrom)
                }else if(sensor.value >= chart.rangeTo){
                    percent = 1
                }else{
                    percent = 0
                }  coldColor = root.controller.faceConfiguration.coldColor
                hotColor = root.controller.faceConfiguration.hotColor
            
                resultRed = coldColor.r + (percent * (hotColor.r - coldColor.r))
                resultGreen = coldColor.g + (percent * (hotColor.g - coldColor.g))
                resultBlue = coldColor.b + (percent * (hotColor.b - coldColor.b))
                newColor = Qt.rgba(resultRed,resultGreen,resultBlue,1)
                overlay.color = newColor
                previousSensorValue = sensor.value
                console.log("===============================")
                console.log("sensor.value: " + sensor.value)
                console.log("rangeFrom: " + chart.rangeFrom)
                console.log("rangeTo: " + chart.rangeTo)
                console.log("percent: " + percent)
                console.log("coldColor: " + coldColor)
                console.log("hotColor: " + hotColor)
                console.log("newColor: " + newColor)
            }
        }
    }
}