/*
  * SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
  * 
  * SPDX-License-Identifier: LGPL-2.0-or-later
  */
  
 import QtQuick 6.6
 import QtQuick.Controls 6.6
 import QtQuick.Layouts 6.6
  
 import org.kde.ksysguard.formatter as Formatter
 import org.kde.ksysguard.sensors as Sensors


/**
* A control to select a unit.
*
* This is primarily intended for unit selection in Face configuration pages.
* It allows a unit for that value and provides a unit and a multiplier for that value.
*/
Control {
    id: unitCombo
    /**
    * The unit for the value.
    */
    property int unit
    /**
    * The unit for the value.
    */
    property string symbol
    /**
    * The multiplier to convert the provided value from its unit to the base unit.
    */
    property real multiplier

    /**
    * Emitted whenever the value, unit or multiplier changes due to user input.
    */
    signal valueModified()

    property alias currentIndex : comboBox.currentIndex

    function triggerValue(){
        valueModified()
    }
    
    function incrementCurrentIndex(){
        comboBox.incrementCurrentIndex()
    }

    implicitWidth: leftPadding + comboBox.implicitWidth + rightPadding
    implicitHeight: topPadding + comboBox.implicitHeight + bottomPadding

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    contentItem: RowLayout {
        spacing: 0
        ComboBox {
            id: comboBox
            Layout.fillWidth: true
            Layout.preferredWidth: 0
            visible: unitModel.sensors.length > 0

            textRole: "symbol"
            valueRole: "unit"
            currentIndex: 0

            onActivated: {
                unitCombo.unit = model.data(model.index(currentIndex, 0), Sensors.SensorUnitModel.UnitRole)
                unitCombo.multiplier = model.data(model.index(currentIndex, 0), Sensors.SensorUnitModel.MultiplierRole)
                unitCombo.symbol = model.data(model.index(currentIndex, 0), Sensors.SensorUnitModel.SymbolRole)
                unitCombo.valueModified()
            }
       

            Component.onCompleted: comboBox.updateCurrentIndex()

            model: Sensors.SensorUnitModel {
                id: unitModel
                sensors: controller.highPrioritySensorIds 
                onReadyChanged : comboBox.updateCurrentIndex()
            }

            function updateCurrentIndex() {
                if (unitModel.ready && comboBox.unit >= 0) {
                     currentIndex = indexOfValue(comboBox.unit)
                    unitCombo.valueModified()
                 } else {
                     currentIndex = 0;
                 }
            }
        }
    }
}
