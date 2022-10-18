/*
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.2 as QQC2

import org.kde.kirigami 2.8 as Kirigami

import org.kde.ksysguard.sensors 1.0 as Sensors
import org.kde.ksysguard.faces 1.0 as Faces

Kirigami.FormLayout {
    id: root
    Layout.fillWidth: true

    property alias cfg_showLegend: showSensorsLegendCheckbox.checked
    property alias cfg_smoothEnds: smoothEndsCheckbox.checked

    property alias cfg_rangeAuto: rangeAutoCheckbox.checked
    property alias cfg_rangeFrom: rangeFromSpin.value
    property alias cfg_rangeFromMultiplier: rangeFromSpin.multiplier
    property alias cfg_rangeTo: rangeToSpin.value
    property alias cfg_rangeToMultiplier: rangeToSpin.multiplier
    property alias cfg_coldColor: coldColor.color
    property alias cfg_hotColor: hotColor.color

    Row {
        spacing: 15
        Rectangle{
            id: coldColor
            color: cfg_coldColor
            width: 20
            height: 20
            visible: true
            MouseArea {
                anchors.fill: parent
                onClicked: coldColorDialog.open()
            }   
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter 
            color: Kirigami.Theme.textColor
            text: i18n("Cold temp color")
        }
        
        ColorDialog {
            id: coldColorDialog
            title: "Please choose a color"
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
    }

     Row {
        spacing: 15
        Rectangle{
            id: hotColor
            color: cfg_hotColor
            width: 20
            height: 20
            visible: true
            MouseArea {
                anchors.fill: parent
                onClicked: hotColorDialog.open()
            }   
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter 
            color: Kirigami.Theme.textColor
            text: i18n("Hot temp color")
        }
        
        ColorDialog {
            id: hotColorDialog
            title: "Please choose a color"
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
    QQC2.CheckBox {
        id: showSensorsLegendCheckbox
        text: i18n("Show Sensors Legend")
    }
    QQC2.CheckBox {
        id: smoothEndsCheckbox
        text: i18n("Rounded Lines")
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
