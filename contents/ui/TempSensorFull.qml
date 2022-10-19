import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2 as QQC2

import QtGraphicalEffects 1.12

import org.kde.ksysguard.sensors 1.0 as Sensors
import org.kde.ksysguard.faces 1.0 as Faces

import org.kde.quickcharts 1.0 as Charts
import org.kde.quickcharts.controls 1.0 as ChartControls
import org.kde.plasma.core 2.0 as PlasmaCore

ColumnLayout {
    id: tempSensorFull
    Layout.fillHeight: true
    Layout.alignment : Qt.AlignHCenter | Qt.AlignTop

    ColorUtils.Gradien {
        id : gradien
    }

    Sensors.Sensor {
        id: sensor
        sensorId: root.controller.totalSensors.length > 0 ? root.controller.totalSensors[0] : ""
        updateRateLimit: 1000
    }

    Item {
        id: iconTemp
        visible: true
        Layout.fillHeight: true
        Layout.alignment : Qt.AlignHCenter | Qt.AlignTop

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
            anchors.centerIn: parent
            width: height / iconSvg.ratio
            height:  parent.height
            svg: iconSvg

        }

        ColorOverlay{
            id: overlay
            anchors.fill: svgItem
            Layout.fillHeight: true
            anchors.centerIn: parent
            Layout.alignment : Qt.AlignHCenter | Qt.AlignTop
            source:svgItem
            color: Qt.rgba(0,0,0,0)
            antialiasing: true
            visible : sensor.value > 0.0
        }


        QQC2.Label {
            id: label
            visible: true
            text: sensor.value != null ? sensor.value.toFixed(2)+ "°C" : "--.--°C"
            Layout.alignment : Qt.AlignHCenter | Qt.AlignTop
            z:1
            height : 0
            anchors {
                bottom: svgItem.bottom
                bottomMargin: svgItem.height * 0.2
            }   
            font.bold: true
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
                const sensorValue = sensor.value
                if(sensorValue != null && sensorValue != previousSensorValue){
                    var mix = 0
                    if(sensorValue > chart.rangeFrom && sensorValue < chart.rangeTo){
                        mix = (sensorValue - chart.rangeFrom) / (chart.rangeTo - chart.rangeFrom)
                    }else if(sensorValue >= chart.rangeTo){
                        // Temp overshoot max
                        mix = 1
                        iconSvg.imagePath=Qt.resolvedUrl(iconTemp.temp_hot_icon)
                    }else{
                        // Temp is lower than min
                        mix = 0
                        iconSvg.imagePath=Qt.resolvedUrl(iconTemp.temp_cold_icon)
                    }  
                    // Manage intermediate temp icon
                    if(mix > 0 && mix <= 0.33){
                        iconSvg.imagePath=Qt.resolvedUrl(iconTemp.temp_low_icon)
                    }
                    if(mix > 0.33 && mix <= 0.66){
                        iconSvg.imagePath=Qt.resolvedUrl(iconTemp.temp_half_icon)
                    }
                    if(mix > 0.66 && mix < 1){
                        iconSvg.imagePath=Qt.resolvedUrl(iconTemp.temp_high_icon)
                    }
                    // Get cold and hot colors
                    var coldColor = root.controller.faceConfiguration.coldColor
                    var hotColor = root.controller.faceConfiguration.hotColor
                    // Calculate new RGB color
                    overlay.color = gradien.generateGradient(coldColor,hotColor,mix)
                    // Save actual temp to avoid useless refresh
                    previousSensorValue = sensorValue
                }
            }  
        }
    }


}
