import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2 as QQC2

import QtGraphicalEffects 1.12

import org.kde.ksysguard.sensors 1.0 as Sensors
import org.kde.ksysguard.faces 1.0 as Faces

import org.kde.quickcharts 1.0 as Charts
import org.kde.quickcharts.controls 1.0 as ChartControls
import org.kde.plasma.core 2.0 as PlasmaCore

RowLayout {
    spacing: 18
    id: tempSensor
    Sensors.Sensor {
            id: sensor
            sensorId: root.controller.totalSensors.length > 0 ? root.controller.totalSensors[0] : ""
            updateRateLimit: 1000
        }
    QQC2.Label {
        id: label
        visible: true
        text: sensor.value.toFixed(2) + "°C"
    }
    Item {
        id: iconTemp
        visible: true
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.rightMargin: 18

        readonly property string no_temp_icon: "../images/no_temp.svg"
        readonly property string temp_cold_icon: "../images/temp_cold.svg"
        readonly property string temp_low_icon: "../images/temp_low.svg"
        readonly property string temp_half_icon: "../images/temp_half.svg"
        readonly property string temp_high_icon: "../images/temp_high.svg"
        readonly property string temp_hot_icon: "../images/temp_hot.svg"

        PlasmaCore.Svg {
            id: iconSvg
            imagePath: Qt.resolvedUrl(iconTemp.no_temp_icon)
            property double ratio : 1.84
        }

        PlasmaCore.SvgItem {
            id: svgItem
            visible: false
            width: height / iconSvg.ratio
            height:  parent.height

            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            svg: iconSvg
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
                    var percent = 0
                    if(sensor.value > chart.rangeFrom && sensor.value < chart.rangeTo){
                        percent = (sensor.value - chart.rangeFrom) / (chart.rangeTo - chart.rangeFrom)
                    }else if(sensor.value >= chart.rangeTo){
                        // Temp overshoot max
                        percent = 1
                        iconSvg.imagePath=Qt.resolvedUrl(iconTemp.temp_hot_icon)
                    }else{
                        // Temp is lower than min
                        percent = 0
                        iconSvg.imagePath=Qt.resolvedUrl(iconTemp.temp_cold_icon)
                    }  
                    // Manage intermediate temp icon
                    if(percent > 0 && percent <= 0.33){
                        iconSvg.imagePath=Qt.resolvedUrl(iconTemp.temp_low_icon)
                    }
                    if(percent > 0.33 && percent <= 0.66){
                        iconSvg.imagePath=Qt.resolvedUrl(iconTemp.temp_half_icon)
                    }
                    if(percent > 0.66 && percent < 1){
                        iconSvg.imagePath=Qt.resolvedUrl(iconTemp.temp_high_icon)
                    }
                    // Get cold and hot colors
                    var coldColor = root.controller.faceConfiguration.coldColor
                    var hotColor = root.controller.faceConfiguration.hotColor
                
                    // Calculate new RGB color
                    var resultRed = coldColor.r + (percent * (hotColor.r - coldColor.r))
                    var resultGreen = coldColor.g + (percent * (hotColor.g - coldColor.g))
                    var resultBlue = coldColor.b + (percent * (hotColor.b - coldColor.b))
                    var newColor = Qt.rgba(resultRed,resultGreen,resultBlue,1)
                    // Apply new RGB color on top of svg
                    overlay.color = newColor
                    label.color = newColor
                    // Save actual temp to avoid useless refresh
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
}
