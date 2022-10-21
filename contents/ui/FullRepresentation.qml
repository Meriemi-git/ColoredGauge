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

Representation {
    id: root
    contentItem: ColumnLayout  {    
        Kirigami.Heading {
            id: heading
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            text: root.controller.title
            visible: !root.levelMode && !root.forceCompact && root.showSensorTitle && text.length > 0 
            level: 2
            color : root.actualColor
        }
        BigTemp {
            visible: !root.levelMode && !root.forceCompact
            actualColor : root.actualColor
            sensorValue : root.sensorValue
            mix : root.mix
        }
        LittleTemp {
            visible : !root.levelMode && root.forceCompact
            actualColor : root.actualColor
            sensorValue : root.sensorValue
            mix : root.mix
        }
        PieChart {
            id: pieChart
            visible : root.levelMode
            Layout.maximumHeight: Math.max(root.width, Layout.minimumHeight)
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            updateRateLimit: root.controller.updateRateLimit
            actualColor: root.actualColor
        }
        Faces.ExtendedLegend {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: root.formFactor === Faces.SensorFace.Horizontal
                || root.formFactor === Faces.SensorFace.Vertical
                ? implicitHeight
                : Kirigami.Units.gridUnit
            visible: root.showLegend
            chart: pieChart.chart
            sourceModel: root.showLegend ? pieChart.sensorsModel : null
            sensorIds: root.showLegend ? root.controller.lowPrioritySensorIds : []
            updateRateLimit: root.controller.updateRateLimit
        }
    }
}   