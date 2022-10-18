/*
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.9
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Layouts 1.1

import org.kde.kirigami 2.8 as Kirigami

import org.kde.ksysguard.sensors 1.0 as Sensors
import org.kde.ksysguard.faces 1.0 as Faces

import org.kde.quickcharts 1.0 as Charts
import org.kde.quickcharts.controls 1.0 as ChartControls
import org.kde.plasma.core 2.0 as PlasmaCore

Faces.SensorFace {
    id: root
    contentItem: RowLayout  {
        spacing: 18

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
        IconTemp{
            visible: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.rightMargin: 18
        }
    }

}
