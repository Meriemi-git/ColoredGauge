/*
    SPDX-License-Identifier: LGPL-2.0-or-later
*/
import Qt5Compat.GraphicalEffects
import QtQml.Models 6.6
import QtQuick 6.6
import QtQuick.Controls 6.6 as QQC2
import QtQuick.Dialogs 6.6 as QQD
import QtQuick.Layouts 6.6
import org.kde.kirigami as Kirigami
import org.kde.ksvg 1.0 as KSvg
import org.kde.ksysguard.faces as Faces
import org.kde.ksysguard.sensors as Sensors
import org.kde.plasma.components 3.0 as PC3

ColumnLayout {

    id: config

    property alias cfg_showLegend: showSensorsLegendCheckbox.checked
    property alias cfg_rangeAuto: rangeAuto.checked
    property alias cfg_rangeFrom: rangeFrom.value
    property alias cfg_rangeTo: rangeTo.value
    property alias cfg_lowValueColor: lowValueColor.color
    property alias cfg_highValueColor: highValueColor.color
    property alias cfg_showValue: showValue.checked
    property alias cfg_showIcon: showIcon.checked
    property alias cfg_showTitle: showTitle.checked
    property alias cfg_colorized: colorized.checked
    property alias cfg_showUnit: showUnit.checked
    property alias cfg_decimals: decimals.value
    property alias cfg_unitAuto: unitAuto.checked
    property alias cfg_symbol: unitCombo.symbol
    property alias cfg_multiplier: unitCombo.multiplier
    property alias cfg_backgroundOpacity: backgroundOpacity.value
    property alias cfg_backgroundColor: backgroundColor.color
    property alias cfg_textOnSide: textOnSide.checked
    property alias cfg_svgFrames: gridView.svgs
    property alias cfg_titleTopMargin: titleTopMargin.value
    property alias cfg_titleRightMargin: titleRightMargin.value
    property alias cfg_titleBottomMargin: titleBottomMargin.value
    property alias cfg_titleLeftMargin: titleLeftMargin.value
    property alias cfg_titleSize: titleSize.value
    property alias cfg_valueTopPadding: valueTopPadding.value
    property alias cfg_valueRightPadding: valueRightPadding.value
    property alias cfg_valueBottomPadding: valueBottomPadding.value
    property alias cfg_valueLeftPadding: valueLeftPadding.value
    property alias cfg_valueSize: valueSize.value
    property alias cfg_minimumWidgetWith: minimumWidgetWith.value
    property alias cfg_iconIndex: comboIcon.currentIndex
    property string actualValue
    property color actualColor: lowValueColor.color
    property string actualSymbol
    property string actualFramePath
    property var customFramesAlignCenter

    function refreshVisualisation() {
        svgAnimator.updateFramePath();
        svgAnimator.updateActualColor();
        compositionTab.updateListModel();
    }

    Component.onCompleted: {
    }
    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
    width: parent.width
    height: parent.height

    ColorUtils.Gradien {
        id: gradien
    }

    SensorAnimator {
        id: svgAnimator

        name: "config"
        sensorDataModel: sensorDataModel
        unitModel: unitModel
        svgFrames: cfg_svgFrames
        rangeFrom: cfg_rangeFrom
        rangeAuto: cfg_rangeAuto
        rangeTo: cfg_rangeTo
        lowValueColor: cfg_lowValueColor
        highValueColor: cfg_highValueColor
        overridedSymbol: cfg_symbol
        multiplier: cfg_multiplier
        decimals: cfg_decimals
        onSensorValueChanged: (sensorValue) => {
            config.actualValue = sensorValue;
        }
        onSymbolChanged: (symbol) => {
            config.actualSymbol = symbol;
        }
        onActualFramePathChanged: (actualFramePath) => {
            config.actualFramePath = actualFramePath;
        }
        onActualColorChanged: (actualColor) => {
            config.actualColor = actualColor;
        }
    }

    Sensors.SensorDataModel {
        id: sensorDataModel

        sensors: controller.highPrioritySensorIds
        updateRateLimit: controller.updateRateLimit
        sensorLabels: controller.sensorLabels
    }

    Sensors.SensorUnitModel {
        id: unitModel

        sensors: controller.highPrioritySensorIds
    }

    Rectangle {
        color: "transparent"
        height: 50
        width: 50
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        IconWidget {
            id: iconWidget

            actualColor: config.actualColor
            title: controller.title
            showValue: cfg_showValue
            showIcon: cfg_showIcon
            showTitle: cfg_showTitle
            textOnSide: cfg_textOnSide
            showUnit: cfg_showUnit
            decimals: cfg_decimals
            svgFrames: cfg_svgFrames
            colorized: cfg_colorized
            symbol: actualSymbol
            value: actualValue
            actualFramePath: config.actualFramePath
            titleTopMargin: cfg_titleTopMargin
            titleRightMargin: cfg_titleRightMargin
            titleBottomMargin: cfg_titleBottomMargin
            titleLeftMargin: cfg_titleLeftMargin
            titleSize: cfg_titleSize
            valueTopPadding: cfg_valueTopPadding
            valueRightPadding: cfg_valueRightPadding
            valueBottomPadding: cfg_valueBottomPadding
            valueLeftPadding: cfg_valueLeftPadding
            backgroundColor: cfg_backgroundColor
            backgroundOpacity: cfg_backgroundOpacity
            valueSize: cfg_valueSize

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

        }

    }

    QQC2.TabBar {
        id: tabBar

        width: config.width
        height: tabBar.implicitHeight
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        QQC2.TabButton {
            text: i18n("Display")
            width: config.width / 4
        }

        QQC2.TabButton {
            text: i18n("Data")
            width: config.width / 4
        }

        QQC2.TabButton {
            text: i18n("Icon composition")
            width: config.width / 4
        }

        QQC2.TabButton {
            text: i18n("Positionning")
            width: config.width / 4
        }

    }

    StackLayout {
        id: stackLayout

        width: config.width
        height: config.height
        currentIndex: tabBar.currentIndex

        QQC2.ScrollView {
            QQC2.ScrollBar.horizontal.policy: QQC2.ScrollBar.AlwaysOff
            height: 300

            RowLayout {
                id: displayTab

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.minimumWidth: config.width / 2

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.fillWidth: true

                        QQC2.Label {
                            color: Kirigami.Theme.textColor
                            text: i18n("Low color")
                        }

                        Rectangle {
                            id: lowValueColor

                            color: cfg_lowValueColor
                            width: 20
                            height: 20
                            visible: true
                            QQC2.ToolTip.visible: color_cold_hover.hovered
                            QQC2.ToolTip.text: i18n("Set the initial color for lower values on the gradient")

                            MouseArea {
                                anchors.fill: parent
                                onClicked: lowValueColorDialog.open()

                                HoverHandler {
                                    id: color_cold_hover

                                    acceptedDevices: PointerDevice.Mouse
                                    cursorShape: Qt.PointingHandCursor
                                }

                            }

                        }

                        QQD.ColorDialog {
                            id: lowValueColorDialog

                            title: i18n("Please choose a color")
                            selectedColor: cfg_lowValueColor
                            onAccepted: {
                                cfg_lowValueColor = lowValueColorDialog.selectedColor;
                                compositionTab.updateListModel();
                                Qt.quit();
                            }
                            onRejected: {
                                Qt.quit();
                            }
                            visible: false
                            modality: Qt.WindowModal
                        }

                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.fillWidth: true

                        QQC2.Label {
                            color: Kirigami.Theme.textColor
                            text: i18n("High color")
                        }

                        Rectangle {
                            id: highValueColor

                            color: cfg_highValueColor
                            width: 20
                            height: 20
                            visible: true
                            QQC2.ToolTip.visible: color_hot_hover.hovered
                            QQC2.ToolTip.text: i18n("Set the final color for higher values on the gradient")

                            MouseArea {
                                anchors.fill: parent
                                onClicked: highValueColorDialog.open()

                                HoverHandler {
                                    id: color_hot_hover

                                    acceptedDevices: PointerDevice.Mouse
                                    cursorShape: Qt.PointingHandCursor
                                }

                            }

                        }

                        QQD.ColorDialog {
                            id: highValueColorDialog

                            title: i18n("Please choose a color")
                            selectedColor: cfg_highValueColor
                            onAccepted: {
                                cfg_highValueColor = highValueColorDialog.selectedColor;
                                compositionTab.updateListModel();
                                Qt.quit();
                            }
                            onRejected: {
                                Qt.quit();
                            }
                            visible: false
                            modality: Qt.WindowModal
                        }

                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.fillWidth: true

                        PC3.Label {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            text: i18n("Background opacity")
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                            PC3.Slider {
                                id: backgroundOpacity

                                from: 0
                                to: 1
                                value: 0
                                stepSize: 0.05
                            }

                            PC3.Label {
                                id: sliderValueLabel

                                function formatText(value) {
                                    return value.toFixed(2);
                                }

                                text: formatText(backgroundOpacity.value)
                                Layout.minimumWidth: textMetrics.width

                                TextMetrics {
                                    id: textMetrics

                                    font.family: sliderValueLabel.font.family
                                    font.pointSize: sliderValueLabel.font.pointSize
                                    text: sliderValueLabel.formatText(backgroundOpacity.to)
                                }

                            }

                        }

                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.fillWidth: true

                        QQC2.Label {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            color: Kirigami.Theme.textColor
                            text: i18n("Background color")
                        }

                        Rectangle {
                            id: backgroundColor

                            color: cfg_backgroundColor
                            width: 20
                            height: 20
                            visible: true
                            Layout.alignment: Qt.AlignHCenter
                            QQC2.ToolTip.visible: backgroundColor_hover.hovered
                            QQC2.ToolTip.text: i18n("Set the color for the value background")

                            MouseArea {
                                anchors.fill: parent
                                onClicked: backgroundColorDialog.open()

                                HoverHandler {
                                    id: backgroundColor_hover

                                    acceptedDevices: PointerDevice.Mouse
                                    cursorShape: Qt.PointingHandCursor
                                }

                            }

                        }

                        QQD.ColorDialog {
                            id: backgroundColorDialog

                            title: i18n("Please choose a color")
                            selectedColor: cfg_backgroundColor
                            onAccepted: {
                                cfg_backgroundColor = backgroundColorDialog.selectedColor;
                                Qt.quit();
                            }
                            onRejected: {
                                Qt.quit();
                            }
                            visible: false
                            modality: Qt.WindowModal
                        }

                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.fillWidth: true

                        ListModel {
                            id: iconModel

                            ListElement {
                                text: "Gauge"
                                icon: "gauge"
                                folder: "../images/gauge"
                                nbFrames: 9
                            }

                            ListElement {
                                text: "Temp"
                                icon: "temp"
                                nbFrames: 5
                                folder: "../images/temp"
                            }

                            ListElement {
                                text: "Plane"
                                icon: "plane"
                                nbFrames: 5
                                folder: "../images/plane"
                            }

                            ListElement {
                                text: "Bars"
                                icon: "bars"
                                nbFrames: 11
                                folder: "../images/bars"
                            }

                            ListElement {
                                text: "Circle"
                                icon: "circle"
                                nbFrames: 181
                                folder: "../images/circle"
                            }

                            ListElement {
                                text: "Custom"
                                icon: "custom"
                            }

                        }

                        QQC2.Label {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            color: Kirigami.Theme.textColor
                            text: i18n("Icon selector")
                        }

                        QQC2.ComboBox {
                            id: comboIcon

                            function setIcon(index) {
                                gridView.svgs = [];
                                frameModel.clear();
                                const iconModelFrameStr = iconModel.get(index).frames;
                                const iconModelFolder = iconModel.get(index).folder;
                                const iconModelNbFrames = iconModel.get(index).nbFrames;
                                if (iconModelFrameStr) {
                                    var frames = iconModelFrameStr.split(",");
                                    for (var i = 0; i < frames.length; i++) {
                                        frameModel.append({
                                            "fileUrl": frames[i].toString(),
                                            "idx": i,
                                            "iconColor": "white"
                                        });
                                    }
                                } else if (iconModelFolder) {
                                    for (var i = 0; i < iconModelNbFrames; i++) {
                                        frameModel.append({
                                            "fileUrl": iconModelFolder + "/" + [i] + ".svg",
                                            "idx": i,
                                            "iconColor": "white"
                                        });
                                    }
                                }
                                refreshVisualisation();
                            }

                            implicitContentWidthPolicy: QQC2.ComboBox.WidestTextWhenCompleted
                            width: 50
                            height: 50
                            textRole: "text"
                            valueRole: "icon"
                            currentIndex: -1
                            onActivated: (index) => {
                                comboIcon.setIcon(index);
                            }
                            model: iconModel

                            delegate: QQC2.ItemDelegate {
                                id: delegateRoot

                                text: model.text
                                width: comboIcon.width
                                height: comboIcon.height
                            }

                        }

                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                        QQC2.Label {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            color: Kirigami.Theme.textColor
                            text: i18n("Minimum width")
                        }

                        QQC2.SpinBox {
                            id: minimumWidgetWith

                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            from: 0
                            to: 1000
                        }

                    }

                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.minimumWidth: config.width / 2

                    RowLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.fillWidth: true
                        Layout.leftMargin: 15

                        QQC2.CheckBox {
                            id: showSensorsLegendCheckbox

                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        }

                        QQC2.Label {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            text: i18n("Show legend")
                        }

                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.fillWidth: true
                        Layout.leftMargin: 15

                        QQC2.CheckBox {
                            id: colorized
                        }

                        QQC2.Label {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            text: i18n("Colorized title")
                        }

                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.fillWidth: true
                        Layout.leftMargin: 15

                        QQC2.Label {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            text: i18n("Show icon")
                        }

                        QQC2.CheckBox {
                            id: showIcon

                            nextCheckState: function() {
                                if (checkState === Qt.Checked) {
                                    if (!showValue.checked)
                                        showValue.checked = true;

                                    return Qt.Unchecked;
                                } else {
                                    return Qt.Checked;
                                }
                            }
                        }

                        QQC2.Label {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            text: i18n("and / or")
                        }

                        QQC2.CheckBox {
                            id: showValue

                            nextCheckState: function() {
                                if (checkState === Qt.Checked) {
                                    if (!showIcon.checked)
                                        showIcon.checked = true;

                                    return Qt.Unchecked;
                                } else {
                                    return Qt.Checked;
                                }
                            }
                        }

                        QQC2.Label {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            text: i18n("Show value")
                        }

                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.fillWidth: true
                        Layout.leftMargin: 15

                        QQC2.CheckBox {
                            id: showUnit
                        }

                        QQC2.Label {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            text: i18n("Show unit")
                        }

                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.fillWidth: true
                        Layout.leftMargin: 15

                        QQC2.CheckBox {
                            id: showTitle
                        }

                        QQC2.Label {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            text: i18n("Show title")
                        }

                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.fillWidth: true
                        Layout.leftMargin: 15

                        QQC2.CheckBox {
                            id: textOnSide
                        }

                        QQC2.Label {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            text: i18n("Text on side")
                        }

                    }

                }

            }

        }

        QQC2.ScrollView {
            QQC2.ScrollBar.horizontal.policy: QQC2.ScrollBar.AlwaysOff
            height: 300

            ColumnLayout {
                id: dataTab

                Layout.fillHeight: true
                width: stackLayout.width
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                GridLayout {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.fillWidth: true

                    QQC2.SpinBox {
                        id: decimals

                        from: 0
                        to: 10
                    }

                    QQC2.Label {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        color: Kirigami.Theme.textColor
                        text: i18n("Number of decimals")
                    }

                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                    QQC2.CheckBox {
                        id: rangeAuto

                        text: i18n("Auto data range")
                    }

                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                    QQC2.SpinBox {
                        id: rangeFrom

                        Kirigami.FormData.label: i18n("Min :")
                        Layout.preferredWidth: Kirigami.Units.gridUnit * 10
                        enabled: !rangeAuto.checked
                    }

                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                    QQC2.SpinBox {
                        id: rangeTo

                        Kirigami.FormData.label: i18n("Max :")
                        Layout.preferredWidth: Kirigami.Units.gridUnit * 10
                        enabled: !rangeAuto.checked
                    }

                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                    QQC2.CheckBox {
                        id: unitAuto

                        text: i18n("Auto select unit")
                    }

                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                    UnitCombo {
                        id: unitCombo

                        enabled: !unitAuto.checked
                    }

                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    Rectangle {
                        color: Qt.rgba(0, 0, 0, 0)
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                }

            }

        }

        QQC2.ScrollView {
            QQC2.ScrollBar.horizontal.policy: QQC2.ScrollBar.AlwaysOff
            height: 300

            ColumnLayout {
                id: compositionTab

                function addSVGToListModel(fileUrl) {
                    frameModel.append({
                        "fileUrl": fileUrl.toString().replace("file://", ""),
                        "idx": frameModel.count,
                        "iconColor": "#000000"
                    });
                    const existingFrames = iconModel.get(iconModel.count - 1).frames;
                    iconModel.setProperty((iconModel.count - 1), "frames", existingFrames ? `${existingFrames},${fileUrl}` : fileUrl.toString());
                }

                function updateListModel() {
                    const scale = 1 / frameModel.count;
                    var svgs = [];
                    for (var i = 0; i < frameModel.count; i++) {
                        const mix = scale * i;
                        var iconColor = gradien.generateGradient(lowValueColor.color, highValueColor.color, mix);
                        frameModel.setProperty(i, "iconColor", iconColor.toString());
                        svgs.push(frameModel.get(i).fileUrl);
                    }
                    gridView.svgs = svgs;
                }

                width: stackLayout.width
                height: stackLayout.height

                Connections {
                    function onRowsInserted(data, first, last) {
                        gridView.svgs.push(frameModel.get(first).fileUrl);
                    }

                    function onRowsRemoved(data, first, last) {
                        gridView.svgs.slice(frameModel.get(first));
                    }

                    target: frameModel
                }

                ColumnLayout {
                    visible: comboIcon.currentIndex == iconModel.count - 1

                    GridView {
                        id: gridView

                        property var svgs: []

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        interactive: false
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                        addDisplaced: Transition {
                            NumberAnimation {
                                properties: "x, y"
                                duration: 100
                            }

                        }

                        moveDisplaced: Transition {
                            NumberAnimation {
                                properties: "x, y"
                                duration: 100
                            }

                        }

                        remove: Transition {
                            NumberAnimation {
                                properties: "x, y"
                                duration: 100
                            }

                            NumberAnimation {
                                properties: "opacity"
                                duration: 100
                            }

                        }

                        removeDisplaced: Transition {
                            NumberAnimation {
                                properties: "x, y"
                                duration: 100
                            }

                        }

                        displaced: Transition {
                            NumberAnimation {
                                properties: "x, y"
                                duration: 100
                            }

                        }

                        model: ListModel {
                            id: frameModel
                        }

                        delegate: Item {
                            id: delegateItem

                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            width: 50
                            height: 50

                            Rectangle {
                                id: dragRect

                                property int previousDragItemIndex: index
                                property int dragItemIndex: index

                                width: (svgItem.naturalSize.width / svgItem.naturalSize.height) * height
                                height: svgItem.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                color: "transparent"
                                border.color: Qt.darker(color)
                                Drag.active: mouseArea.drag.active
                                Drag.hotSpot.x: dragRect.width / 2
                                Drag.hotSpot.y: dragRect.height / 2
                                states: [
                                    State {
                                        when: dragRect.Drag.active

                                        ParentChange {
                                            target: dragRect
                                            parent: gridView
                                        }

                                        AnchorChanges {
                                            target: dragRect
                                            anchors.horizontalCenter: undefined
                                            anchors.verticalCenter: undefined
                                        }

                                    }
                                ]

                                MouseArea {
                                    id: mouseArea

                                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                                    anchors.fill: parent
                                    drag.target: dragRect
                                    drag.onActiveChanged: {
                                        dragRect.dragItemIndex = index;
                                        for (var i = 0; i < frameModel.count; i++) {
                                            frameModel.get(i).idx = i;
                                        }
                                        compositionTab.updateListModel();
                                    }
                                    onClicked: (mouse) => {
                                        if (mouse.button == Qt.RightButton) {
                                            frameModel.remove(index, 1);
                                            compositionTab.updateListModel();
                                        }
                                    }
                                }

                                KSvg.SvgItem {
                                    id: svgItem

                                    svg: iconSvg
                                    height: 50
                                    width: (naturalSize.width / naturalSize.height) * height
                                    layer.enabled: true

                                    KSvg.Svg {
                                        id: iconSvg

                                        usingRenderingCache: false
                                        imagePath: Qt.resolvedUrl(model.fileUrl)
                                    }

                                    anchors {
                                        horizontalCenter: parent.horizontalCenter
                                        margins: 10
                                    }

                                    layer.effect: ColorOverlay {
                                        id: overlay

                                        color: model.iconColor
                                        antialiasing: true
                                    }

                                }

                                QQC2.Label {
                                    text: model.idx.toString()
                                    color: "red"

                                    anchors {
                                        horizontalCenter: dragRect.horizontalCenter
                                        top: svgItem.bottom
                                    }

                                }

                            }

                            DropArea {
                                anchors.fill: parent
                                onEntered: (drag) => {
                                    if (drag.source.dragItemIndex == dragRect.dragItemIndex) {
                                        if (dragRect.previousDragItemIndex != dragRect.dragItemIndex)
                                            frameModel.move(dragRect.dragItemIndex, dragRect.previousDragItemIndex, 1);

                                    } else {
                                        drag.source.previousDragItemIndex = drag.source.dragItemIndex;
                                        dragRect.previousDragItemIndex = dragRect.dragItemIndex;
                                        frameModel.move(drag.source.dragItemIndex, dragRect.dragItemIndex, 1);
                                    }
                                }
                            }

                        }

                    }

                    QQC2.Label {
                        Layout.alignment: Qt.AlignHCenter
                        text: i18n("Add svg icons and drag them to create your animation")
                    }

                    QQC2.Button {
                        id: svgButton

                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        icon.name: "list-add"
                        onClicked: fileDialogLoader.active = true

                        Loader {
                            id: fileDialogLoader

                            active: false

                            sourceComponent: QQD.FileDialog {
                                id: fileDialog

                                fileMode: QQD.FileDialog.OpenFiles
                                currentFolder: Qt.resolvedUrl("~/Pictures")
                                nameFilters: ["SVG files (*.svg)", "All files (*)"]
                                onAccepted: {
                                    if (selectedFiles && selectedFiles.length > 1) {
                                        for (var i = 0; i < selectedFiles.length; i++) {
                                            compositionTab.addSVGToListModel(selectedFiles[i]);
                                        }
                                    } else {
                                        compositionTab.addSVGToListModel(selectedFile);
                                    }
                                    refreshVisualisation();
                                    fileDialogLoader.active = false;
                                }
                                onRejected: {
                                    fileDialogLoader.active = false;
                                }
                                Component.onCompleted: open()
                            }

                        }

                    }

                }

                ColumnLayout {
                    visible: comboIcon.currentIndex !== iconModel.count - 1
                    Layout.alignment: Qt.AlignHCenter

                    QQC2.Label {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Icon composition is only available when 'Custom' icon is selected in display tab."
                    }

                }

            }

        }

        QQC2.ScrollView {
            QQC2.ScrollBar.horizontal.policy: QQC2.ScrollBar.AlwaysOff
            height: 300

            RowLayout {
                id: positionTab

                width: stackLayout.width
                height: stackLayout.height

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.minimumWidth: config.width / 2

                    GridLayout {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 3
                        rows: 3
                        uniformCellHeights: true
                        uniformCellWidths: true

                        Rectangle {
                            Layout.column: 0
                            Layout.columnSpan: 1
                            Layout.row: 0
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                        }

                        Rectangle {
                            Layout.column: 1
                            Layout.columnSpan: 1
                            Layout.row: 0
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"

                            ColumnLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillWidth: true

                                QQC2.SpinBox {
                                    id: titleTopMargin

                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    from: -1000
                                    to: 1000
                                }

                                QQC2.Label {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: Kirigami.Theme.textColor
                                    text: i18n("Top padding")
                                }

                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                    verticalCenter: parent.verticalCenter
                                }

                            }

                        }

                        Rectangle {
                            Layout.column: 2
                            Layout.columnSpan: 1
                            Layout.row: 0
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                        }

                        Rectangle {
                            Layout.column: 0
                            Layout.columnSpan: 1
                            Layout.row: 1
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            ColumnLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillWidth: true

                                QQC2.SpinBox {
                                    id: titleLeftMargin

                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    from: -1000
                                    to: 1000
                                }

                                QQC2.Label {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: Kirigami.Theme.textColor
                                    text: i18n("Left padding")
                                }

                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                    verticalCenter: parent.verticalCenter
                                }

                            }

                        }

                        Rectangle {
                            Layout.column: 1
                            Layout.columnSpan: 1
                            Layout.row: 1
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            ColumnLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillWidth: true

                                QQC2.SpinBox {
                                    id: titleSize

                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    from: 0
                                    to: 100
                                }

                                QQC2.Label {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: Kirigami.Theme.textColor
                                    text: i18n("Title Size")
                                }

                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                    verticalCenter: parent.verticalCenter
                                }

                            }

                        }

                        Rectangle {
                            Layout.column: 2
                            Layout.columnSpan: 1
                            Layout.row: 1
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            ColumnLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillWidth: true

                                QQC2.SpinBox {
                                    id: titleRightMargin

                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    from: -1000
                                    to: 1000
                                }

                                QQC2.Label {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: Kirigami.Theme.textColor
                                    text: i18n("Right padding")
                                }

                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                    verticalCenter: parent.verticalCenter
                                }

                            }

                        }

                        Rectangle {
                            Layout.column: 0
                            Layout.columnSpan: 1
                            Layout.row: 2
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                        }

                        Rectangle {
                            Layout.column: 1
                            Layout.columnSpan: 1
                            Layout.row: 2
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            ColumnLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillWidth: true

                                QQC2.SpinBox {
                                    id: titleBottomMargin

                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    from: -1000
                                    to: 1000
                                }

                                QQC2.Label {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: Kirigami.Theme.textColor
                                    text: i18n("Bottom padding")
                                }

                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                    verticalCenter: parent.verticalCenter
                                }

                            }

                        }

                        Rectangle {
                            Layout.column: 2
                            Layout.columnSpan: 1
                            Layout.row: 2
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                        }

                    }

                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.minimumWidth: config.width / 2

                    GridLayout {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 3
                        rows: 3
                        uniformCellHeights: true
                        uniformCellWidths: true

                        Rectangle {
                            Layout.column: 0
                            Layout.columnSpan: 1
                            Layout.row: 0
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                        }

                        Rectangle {
                            Layout.column: 1
                            Layout.columnSpan: 1
                            Layout.row: 0
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"

                            ColumnLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillWidth: true
                                Layout.row: 0
                                Layout.rowSpan: 1
                                Layout.fillHeight: true

                                QQC2.SpinBox {
                                    id: valueTopPadding

                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    from: -1000
                                    to: 1000
                                }

                                QQC2.Label {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: Kirigami.Theme.textColor
                                    text: i18n("Top padding")
                                }

                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                    verticalCenter: parent.verticalCenter
                                }

                            }

                        }

                        Rectangle {
                            Layout.column: 0
                            Layout.columnSpan: 1
                            Layout.row: 1
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            ColumnLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillWidth: true

                                QQC2.SpinBox {
                                    id: valueLeftPadding

                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    from: -1000
                                    to: 1000
                                }

                                QQC2.Label {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: Kirigami.Theme.textColor
                                    text: i18n("Left padding")
                                }

                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                    verticalCenter: parent.verticalCenter
                                }

                            }

                        }

                        Rectangle {
                            Layout.column: 1
                            Layout.columnSpan: 1
                            Layout.row: 1
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            ColumnLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillWidth: true

                                QQC2.SpinBox {
                                    id: valueSize

                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    from: 0
                                    to: 1000
                                }

                                QQC2.Label {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: Kirigami.Theme.textColor
                                    text: i18n("Value Size")
                                }

                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                    verticalCenter: parent.verticalCenter
                                }

                            }

                        }

                        Rectangle {
                            Layout.column: 2
                            Layout.columnSpan: 1
                            Layout.row: 1
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            ColumnLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillWidth: true

                                QQC2.SpinBox {
                                    id: valueRightPadding

                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    from: -1000
                                    to: 1000
                                }

                                QQC2.Label {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: Kirigami.Theme.textColor
                                    text: i18n("Right padding")
                                }

                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                    verticalCenter: parent.verticalCenter
                                }

                            }

                        }

                        Rectangle {
                            Layout.column: 0
                            Layout.columnSpan: 1
                            Layout.row: 2
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                        }

                        Rectangle {
                            Layout.column: 1
                            Layout.columnSpan: 1
                            Layout.row: 2
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            ColumnLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillWidth: true

                                QQC2.SpinBox {
                                    id: valueBottomPadding

                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    from: -1000
                                    to: 1000
                                }

                                QQC2.Label {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: Kirigami.Theme.textColor
                                    text: i18n("Bottom padding")
                                }

                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                    verticalCenter: parent.verticalCenter
                                }

                            }

                        }

                        Rectangle {
                            Layout.column: 2
                            Layout.columnSpan: 1
                            Layout.row: 2
                            Layout.rowSpan: 1
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "Transparent"
                        }

                    }

                }

            }

        }

    }

}
