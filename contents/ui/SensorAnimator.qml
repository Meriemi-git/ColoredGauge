import QtQuick 2.9
import org.kde.ksysguard.sensors as Sensors

Item {
    property string name
    property var sensorDataModel
    property var unitModel
    property var svgFrames
    property real multiplier
    property bool rangeAuto
    property real rangeFrom
    property real rangeTo
    property color lowValueColor
    property color highValueColor
    property string overridedSymbol
    property int decimals
    property string noFrameFound: "../images/not_found.svg"
    property var sensorIndex
    property real defaultMultiplier: 1
    property string defaultSymbol: "!"

    signal symbolChanged(string symbol)
    signal actualFramePathChanged(string actualFramePath)
    signal sensorValueChanged(string sensorValue)
    signal actualColorChanged(color actualColor)

    function updateFramePath(mix) {
        if (svgFrames.length > 0) {
            var interval = 1 / svgFrames.length;
            if (!mix) {
                actualFramePathChanged(Qt.resolvedUrl(svgFrames[0]));
            } else if (mix == 1) {
                actualFramePathChanged(Qt.resolvedUrl(svgFrames[svgFrames.length - 1]));
            } else {
                var svgFrameNumber = Math.ceil(mix / interval);
                if (svgFrameNumber >= svgFrames.length)
                    svgFrameNumber = svgFrames.length - 1;

                actualFramePathChanged(Qt.resolvedUrl(svgFrames[svgFrameNumber]));
            }
        } else {
            actualFramePathChanged(Qt.resolvedUrl(noFrameFound));
        }
    }

    function updateSymbol() {
        if (!overridedSymbol || overridedSymbol == "" || overridedSymbol == "?")
            symbolChanged(defaultSymbol);
        else
            symbolChanged(overridedSymbol);
    }

    function updateSensorValue(value) {
        if (!value || value == 0)
            sensorValueChanged("-_-");

        if (overridedSymbol !== "?") {
            const quotien = value / multiplier;
            sensorValueChanged(quotien.toFixed(decimals).toString());
        } else {
            const quotien = value / defaultMultiplier;
            sensorValueChanged(quotien.toFixed(decimals).toString());
        }
    }

    function getMix(value) {
        var calculatedRangeFrom = 0;
        var calculatedRangeTo = 0;
        if (rangeAuto) {
            calculatedRangeFrom = sensorDataModel.minimum * defaultMultiplier;
            calculatedRangeTo = sensorDataModel.maximum * defaultMultiplier;
        } else {
            calculatedRangeFrom = rangeFrom * multiplier;
            calculatedRangeTo = rangeTo * multiplier;
        }
        if (value > calculatedRangeFrom && value < calculatedRangeTo)
            return (value - calculatedRangeFrom) / (calculatedRangeTo - calculatedRangeFrom);
        else if (value >= calculatedRangeTo)
            return 1;
        else if (value <= calculatedRangeFrom)
            return 0;
    }

    function updateActualColor(mix) {
        if (mix)
            actualColorChanged(gradien.generateGradient(lowValueColor, highValueColor, mix));
        else
            actualColorChanged(lowValueColor);
    }

    Component.onCompleted: {

    }

    Connections {
        function onDataChanged(data) {
            const value = sensorDataModel.data(data, Sensors.SensorDataModel.Value);
            if (defaultSymbol == "!") {
                const formattedValue = sensorDataModel.data(data, Sensors.SensorDataModel.FormattedValue);
                for (var i = 0; i < 10; i++) {
                    const index = unitModel.index(i, 0);
                    if (index.valid) {
                        const unit = unitModel.data(unitModel.index(i, 0), Sensors.SensorUnitModel.UnitRole);
                        const multiplier = unitModel.data(unitModel.index(i, 0), Sensors.SensorUnitModel.MultiplierRole);
                        const symbol = unitModel.data(unitModel.index(i, 0), Sensors.SensorUnitModel.SymbolRole);
                        if (formattedValue.includes(symbol)) {
                            defaultMultiplier = multiplier;
                            defaultSymbol = symbol;
                            break;
                        }
                    }
                }
            }
            if (value != null) {
                const mix = getMix(value);
                updateActualColor(mix);
                updateFramePath(mix);
                updateSensorValue(value);
                updateSymbol();
            }
        }

        target: sensorDataModel
    }

}
