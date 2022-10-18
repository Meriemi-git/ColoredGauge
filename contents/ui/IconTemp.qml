import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2 as Controls
import QtGraphicalEffects 1.12

import org.kde.kirigami 2.8 as Kirigami

import org.kde.ksysguard.sensors 1.0 as Sensors
import org.kde.ksysguard.faces 1.0 as Faces

import org.kde.quickcharts 1.0 as Charts
import org.kde.quickcharts.controls 1.0 as ChartControls

import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: chart
    Layout.minimumWidth: 20
    Layout.minimumHeight: 20
    PlasmaCore.Svg {
        id: gaugeSvg
        imagePath: Qt.resolvedUrl("../images/temperature-icon.svg")
        size: 20
    }

}