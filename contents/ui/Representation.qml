/*
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.9
import QtQuick.Layouts 1.1
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.faces as Faces
import org.kde.ksysguard.sensors as Sensors
import org.kde.plasma.core as PlasmaCore

Faces.SensorFace {
    id: sensorFace

    readonly property bool showLegend: controller.faceConfiguration.showLegend
    readonly property bool showTitle: controller.faceConfiguration.showTitle
    readonly property bool showUnit: controller.faceConfiguration.showUnit
    readonly property bool colorized: controller.faceConfiguration.colorized
    readonly property bool textOnSide: controller.faceConfiguration.textOnSide
    readonly property bool rangeAuto: controller.faceConfiguration.rangeAuto
    readonly property bool showIcon: controller.faceConfiguration.showIcon
    readonly property bool showValue: controller.faceConfiguration.showValue
    readonly property real backgroundOpacity: controller.faceConfiguration.backgroundOpacity
    readonly property real rangeFrom: controller.faceConfiguration.rangeFrom
    readonly property real rangeTo: controller.faceConfiguration.rangeTo
    readonly property real multiplier: controller.faceConfiguration.multiplier
    readonly property int decimals: controller.faceConfiguration.decimals
    readonly property int updateRateLimit: controller.updateRateLimit
    readonly property int titleTopMargin: controller.faceConfiguration.titleTopMargin
    readonly property int titleRightMargin: controller.faceConfiguration.titleRightMargin
    readonly property int titleBottomMargin: controller.faceConfiguration.titleBottomMargin
    readonly property int titleLeftMargin: controller.faceConfiguration.titleLeftMargin
    readonly property int titleSize: controller.faceConfiguration.titleSize
    readonly property int valueTopPadding: controller.faceConfiguration.valueTopPadding
    readonly property int valueRightPadding: controller.faceConfiguration.valueRightPadding
    readonly property int valueBottomPadding: controller.faceConfiguration.valueBottomPadding
    readonly property int valueLeftPadding: controller.faceConfiguration.valueLeftPadding
    readonly property int valueSize: controller.faceConfiguration.valueSize
    readonly property int minimumWidgetWith: controller.faceConfiguration.minimumWidgetWith
    readonly property string symbol: controller.faceConfiguration.symbol
    readonly property string title: controller.title
    readonly property color lowValueColor: controller.faceConfiguration.lowValueColor
    readonly property color highValueColor: controller.faceConfiguration.highValueColor
    readonly property color backgroundColor: controller.faceConfiguration.backgroundColor
    readonly property var svgFrames: controller.faceConfiguration.svgFrames
    property alias sensorDataModel: sensorDataModel
    property alias unitModel: unitModel
    property color actualColor: lowValueColor
    property string actualFramePath
    property string actualValue
    property string actualSymbol

    ColorUtils.Gradien {
        id: gradien
    }

    Sensors.SensorDataModel {
        id: sensorDataModel

        sensors: sensorFace.controller.highPrioritySensorIds
        updateRateLimit: sensorFace.updateRateLimit
        sensorLabels: sensorFace.controller.sensorLabels
    }

    Sensors.SensorUnitModel {
        id: unitModel

        sensors: controller.highPrioritySensorIds
    }

    SensorAnimator {
        id: svgAnimator

        name: "widget"
        sensorDataModel: sensorFace.sensorDataModel
        unitModel: sensorFace.unitModel
        svgFrames: sensorFace.svgFrames
        rangeAuto: sensorFace.rangeAuto
        rangeFrom: sensorFace.rangeFrom
        rangeTo: sensorFace.rangeTo
        lowValueColor: sensorFace.lowValueColor
        highValueColor: sensorFace.highValueColor
        overridedSymbol: sensorFace.symbol
        multiplier: sensorFace.multiplier
        decimals: sensorFace.decimals
        onSensorValueChanged: (sensorValue) => {
            sensorFace.actualValue = sensorValue;
        }
        onSymbolChanged: (symbol) => {
            sensorFace.actualSymbol = symbol;
        }
        onActualFramePathChanged: (actualFramePath) => {
            sensorFace.actualFramePath = actualFramePath;
        }
        onActualColorChanged: (actualColor) => {
            sensorFace.actualColor = actualColor;
        }
    }

}
