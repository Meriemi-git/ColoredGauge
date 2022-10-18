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

Faces.SensorFace {
    id: root
    contentItem: ColumnLayout {
        QQC2.Label {
            id: label
            visible: true
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: "test"
        }
    }
}
