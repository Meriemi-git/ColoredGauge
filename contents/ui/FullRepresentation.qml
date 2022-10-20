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
    contentItem: ColumnLayout  {
        Layout.maximumWidth:40
        Layout.maximumHeight:40
        Kirigami.Heading {
            id: heading
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            text: root.controller.title
            visible: text.length > 0
            level: 2
        }
        TempSensorFull {
            Layout.fillHeight: true
            Layout.alignment : Qt.AlignHCenter | Qt.AlignTop
        }
    }   
}