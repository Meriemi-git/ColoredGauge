/*
    SPDX-License-Identifier: LGPL-2.0-or-later
*/
import QtQuick 2.9
import QtQuick.Layouts 1.1 


ColumnLayout {

    readonly property bool showText : root.controller.faceConfiguration.showText
    readonly property bool showIcon : root.controller.faceConfiguration.showIcon
    readonly property bool roundedValue : root.controller.faceConfiguration.roundedValue

    readonly property string no_temp_icon: "../images/no_temp.svg"
    readonly property string temp_cold_icon: "../images/temp_cold.svg"
    readonly property string temp_low_icon: "../images/temp_low.svg"
    readonly property string temp_half_icon: "../images/temp_half.svg"
    readonly property string temp_high_icon: "../images/temp_high.svg"
    readonly property string temp_hot_icon: "../images/temp_hot.svg"

    property color actualColor 
    property double sensorValue
    property double mix 

    function getImagePathFromValue(mix){            
        if(mix == 1.0){
            // Temp overshoot max
            return Qt.resolvedUrl(temp_hot_icon)
        }
        if (mix == 0.){
            // Temp is lower than min
            return Qt.resolvedUrl(temp_cold_icon)
        }  
        // Manage intermediate temp icon
        if(mix > 0 && mix <= 0.33){
            return Qt.resolvedUrl(temp_low_icon)
        }
        if(mix > 0.33 && mix <= 0.66){
            return Qt.resolvedUrl(temp_half_icon)
        }
        if(mix > 0.66 && mix < 1){
            return Qt.resolvedUrl(temp_high_icon)
        }
    }

}
