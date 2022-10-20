/*
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.2 as QQC2
import QtGraphicalEffects 1.12
import org.kde.kirigami 2.8 as Kirigami

import org.kde.ksysguard.sensors 1.0 as Sensors
import org.kde.ksysguard.faces 1.0 as Faces

Kirigami.FormLayout {
    id: root
    
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter

    property alias cfg_showLegend: showSensorsLegendCheckbox.checked
    property alias cfg_smoothEnds: smoothEndsCheckbox.checked
    
    // property alias cfg_fromAngle: fromAngleSpin.value
    property alias cfg_toAngle: toAngleSpin.value

    property alias cfg_rangeAuto: rangeAutoCheckbox.checked

    property alias cfg_rangeFrom: rangeFromSpin.value
    property alias cfg_rangeFromMultiplier: rangeFromSpin.multiplier
    property alias cfg_rangeTo: rangeToSpin.value
    property alias cfg_rangeToMultiplier: rangeToSpin.multiplier

    property alias cfg_coldColor: coldColor.color
    property alias cfg_hotColor: hotColor.color

    property alias cfg_showText: showText.checked
    property alias cfg_showIcon: showIcon.checked
    property alias cfg_showSensorTitle: showSensorTitle.checked
    property alias cfg_colorizedSensorTitle: colorizedSensorTitle.checked
    property alias cfg_roundedValue: roundedValue.checked
    property alias cfg_forceCompact: forceCompact.checked
    Kirigami.Separator{
        Kirigami.FormData.isSection: true
    }

    ColumnLayout{
        spacing: 5
        Row {
            spacing: 15
            QQC2.Label {
                color: Kirigami.Theme.textColor
                text: i18n("Cold color")
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle{
                id: coldColor
                color: cfg_coldColor
                width: 20
                height: 20
                visible: true
                MouseArea {
                    onClicked: coldColorDialog.open()
                }
                Layout.alignment: Qt.AlignHCenter   
            }
            ColorDialog {
                id: coldColorDialog
                title: i18n("Please choose a color")
                color: cfg_coldColor
                onAccepted: {
                    cfg_coldColor = coldColorDialog.color
                    Qt.quit()
                }
                onRejected: {
                    Qt.quit()
                }
                visible: false
                modality: Qt.WindowModal
            }

            QQC2.Label {
                color: Kirigami.Theme.textColor
                text: i18n("Hot color")
            }

            Rectangle{
                id: hotColor
                color: cfg_hotColor
                width: 20
                height: 20
                visible: true
                MouseArea {
                    onClicked: hotColorDialog.open()
                }   
            }

            ColorDialog {
                id: hotColorDialog
                title: i18n("Please choose a color")
                color: cfg_hotColor
                onAccepted: {
                    cfg_hotColor = hotColorDialog.color
                    Qt.quit()
                }
                onRejected: {
                    Qt.quit()
                }
                visible: false
                modality: Qt.WindowModal
            }
        }

        Row {

            QQC2.CheckBox {
                id: showText
                text: i18n("Show text")
                nextCheckState: function() {
                    if (checkState === Qt.Checked){
                       if(!showIcon.checked){
                            showIcon.checked = true
                        }
                        return Qt.Unchecked
                    }
                    else{
                         return Qt.Checked
                    }
                        
                }
            }

            QQC2.CheckBox {
                id: showIcon
                text: i18n("Show icon")
                nextCheckState: function() {
                    if (checkState === Qt.Checked){
                       if(!showText.checked){
                            showText.checked = true
                        }
                        return Qt.Unchecked
                    }
                    else{
                         return Qt.Checked
                    }
                        
                }            
            }
        }
        QQC2.CheckBox {
            id: showSensorTitle
            text: i18n("Show Sensors title")
        }
        QQC2.CheckBox {
            id: showSensorsLegendCheckbox
            text: i18n("Show Sensors Legend")
        }
        QQC2.CheckBox {
            id: colorizedSensorTitle
            text: i18n("Colorized sensor title")
        }
         QQC2.CheckBox {
            id: forceCompact
            text: i18n("Force compact mode")
        }
        QQC2.CheckBox {
            id: roundedValue
            text: i18n("Rounded value")
        }
        QQC2.CheckBox {
            id: rangeAutoCheckbox
            text: i18n("Automatic Data Range")
        }
        
        Faces.SensorRangeSpinBox {
            id: rangeFromSpin
            Kirigami.FormData.label: i18n("Min :")
            Layout.preferredWidth: Kirigami.Units.gridUnit * 10
            enabled: !rangeAutoCheckbox.checked
            sensors: controller.highPrioritySensorIds
        }
        Faces.SensorRangeSpinBox {
            id: rangeToSpin
            Kirigami.FormData.label: i18n("Max :")
            Layout.preferredWidth: Kirigami.Units.gridUnit * 10
            enabled: !rangeAutoCheckbox.checked
            sensors: controller.highPrioritySensorIds
        }
    }

    Kirigami.Separator{
        Kirigami.FormData.isSection: true
    }

    ColumnLayout{
        spacing : 5
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter    

        QQC2.Label{
            text : i18n("Activity sensor")
            horizontalAlignment : Text.AlignHCenter
            Layout.fillWidth: true
            
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter    

            QQC2.Label {
                color: Kirigami.Theme.textColor
                text: i18n("Start from Angle")  
            }

            QQC2.SpinBox {
                id: fromAngleSpin
                from: -180
                to: 360
                editable: true
                textFromValue: function(value, locale) {
                    return i18nc("angle degrees", "%1°", value);
                }
                valueFromText: function(text, locale) {
                    return Number.fromLocaleString(locale, text.replace(i18nc("angle degrees", "°"), ""));
                }
            }
        }
        
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter    
            QQC2.Label {
                id: test
                color: Kirigami.Theme.textColor
                text: i18n("Total Pie Angle")               
            }
            QQC2.SpinBox {
                id: toAngleSpin
                from: 0
                to: 360
                editable: true
                textFromValue: function(value, locale) {
                    return i18nc("angle", "%1°", value);
                }
                valueFromText: function(text, locale) {
                    return Number.fromLocaleString(locale, text.replace(i18nc("angle degrees", "°"), ""));
                }
            }
        }

        QQC2.CheckBox {
            id: smoothEndsCheckbox
            text: i18n("Rounded Lines")
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
