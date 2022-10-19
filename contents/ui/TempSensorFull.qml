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

    Sensors.Sensor {
        id: sensor
        sensorId: root.controller.totalSensors.length > 0 ? root.controller.totalSensors[0] : ""
        updateRateLimit: 1000
    }


    QQC2.Label {
        id: label
        visible: true
        text: sensor.value.toFixed(2)
        Layout.alignment : Qt.AlignHCenter | Qt.AlignTop
        z:1
        anchors {
            bottom: parent.bottom
             bottomMargin: 30
        }   
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
            Layout.fillHeight: true
            Layout.alignment : Qt.AlignHCenter | Qt.AlignTop
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
            visible : chart.sensor.value > 0.0
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
                    console.log("sensorValue",sensorValue)
                    console.log("rangeTo",chart.rangeTo)
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
                    chart.generateGradient(coldColor,hotColor, mix)
                    // Calculate new RGB color
                    var resultRed = coldColor.r + (mix * (hotColor.r - coldColor.r))
                    var resultGreen = coldColor.g + (mix * (hotColor.g - coldColor.g))
                    var resultBlue = coldColor.b + (mix * (hotColor.b - coldColor.b))
                    var newColor = Qt.rgba(resultRed,resultGreen,resultBlue,1)
                    // Apply new RGB color on top of svg
                    overlay.color = chart.generateGradient(coldColor,hotColor,mix)
                    // Save actual temp to avoid useless refresh
                    previousSensorValue = sensorValue
                    // console.log("===============================")
                    // console.log("sensor.value: " + sensorValue)
                    // console.log("rangeFrom: " + chart.rangeFrom)
                    // console.log("rangeTo: " + chart.rangeTo)
                    // console.log("mix: " + mix)
                    // console.log("coldColor: " + coldColor)
                    // console.log("hotColor: " + hotColor)
                    // console.log("newColor: " + newColor)
                }
            }

            /**
             ** Generate gradient with better colors than simple linear interpolation
             ** @see https://stackoverflow.com/questions/22607043/color-gradient-algorithm
             ** Mark Ransom response : 
             ** The intensity of the gradient must be constant in a perceptual color space 
             ** or it will look unnaturally dark or light at points in the gradient. 
             ** You can see this easily in a gradient based on simple interpolation of the sRGB values, 
             ** particularly the red-green gradient is too dark in the middle. Using interpolation on linear values 
             ** rather than gamma-corrected values makes the red-green gradient better, but at the expense of the back-white gradient. 
             ** By separating the light intensities from the color you can get the best of both worlds.
             ** Often when a perceptual color space is required, the Lab color space will be proposed. 
             ** I think sometimes it goes too far, because it tries to accommodate the perception that blue 
             ** is darker than an equivalent intensity of other colors such as yellow. This is true, but we are used to seeing this effect in our natural environment and in a gradient you end up with an overcompensation.
             ** A power-law function of 0.43 was experimentally determined by researchers to be the best fit for relating gray light intensity to perceived brightness.
             **/
            function generateGradient(cold, hot, mix){
                console.log('mix',mix)
                // var c1n = chart.normalize(cold)
                // var c2n = chart.normalize(hot)
                var c1s = chart.inverseSrgbCompanding(cold)
                var c2s = chart.inverseSrgbCompanding(hot)

                var newR = chart.interpolateLinear(c1s.r,c2s.r,mix)
                var newG = chart.interpolateLinear(c1s.g,c2s.g,mix)
                var newB = chart.interpolateLinear(c1s.b,c2s.b,mix)

                // Compute a measure of brightness of the two colors using empirically determined gamma
                var gamma =  0.43
                var brightness1 = Math.pow(c1s.r+c1s.g+c1s.b, gamma)
                var brightness2 = Math.pow(c2s.r+c2s.g+c2s.b, gamma)

                // Interpolate a new brightness value, and convert back to linear light
                var brightness = chart.interpolateLinear(brightness1, brightness2, mix)
                var intensity = Math.pow(brightness, 1/gamma)

                // Apply adjustment factor to each rgb value based
                if ((newR+newG+newB) != 0) {
                   var factor = intensity / (newR+newG+newB)
                   newR = newR * factor
                   newG = newG * factor
                   newB = newB * factor
                }
                var rgb = {
                    r: newR,
                    g: newG,
                    b: newB
                }
                var newRGB = chart.srgbCompanding(rgb)
                var newColor = Qt.rgba(newRGB.r,newRGB.g,newRGB.b,1)
                console.log("newColor",newColor)
                return newColor
            }
            /**
             ** Convert color from 0..255 to 0..1
             **/
            function normalize(color){
                return {
                    r : color.r / 255,
                    g : color.g / 255,
                    b : color.b / 255,
                }
            }
            /**
             ** Apply sRGB companding to convert each channel into linear light
             **/
            function srgbCompanding(color){
                var newR = 0
                var newG = 0
                var newB = 0

                // Apply companding to Red, Green, and Blue
                if (color.r > 0.0031308) {newR = 1.055*Math.pow(color.r, 1/2.4)-0.055} else {newR = color.r * 12.92;}
                if (color.g > 0.0031308) {newG = 1.055*Math.pow(color.g, 1/2.4)-0.055} else {newG = color.g * 12.92;}
                if (color.b > 0.0031308) {newB = 1.055*Math.pow(color.b, 1/2.4)-0.055} else {newB = color.b * 12.92;}
                return {
                    r : newR,
                    g : newG,
                    b : newB,
                }
            }
            /**
             ** Apply inverse sRGB companding to convert each channel into linear light
             **/
            function inverseSrgbCompanding(color){
                var newR = 0.0
                var newG = 0.0
                var newB = 0.0

                console.log(`color ${color.r} ${color.g} ${color.b}`)

                // Apply companding to Red, Green, and Blue
                if (color.r > 0.04045) {
                    newR = Math.pow((color.r+0.055)/1.055, 2.4)
                    console.log('color.r',color.r)
                    console.log('newR', Math.pow((color.r+0.055)/1.055, 2.4))
                } else {
                    newR = color.r / 12.92;
                }
                if (color.g > 0.04045) {
                    newG = Math.pow((color.g+0.055)/1.055, 2.4)

                } else {
                    newG = color.g / 12.92;
                }
                if (color.b > 0.04045) {
                    newB = Math.pow((color.b+0.055)/1.055, 2.4)
                } else {
                    newB = color.b / 12.92;
                }
                
                return {
                    r : newR,
                    g : newG,
                    b : newB,
                }
            }
            /**
             ** Linearly interpolate values using mix (0..1)
             **/
            function interpolateLinear(c1, c2, mix){
                return c1 * (1-mix) + c2 * mix
            }
        }
    }
}
