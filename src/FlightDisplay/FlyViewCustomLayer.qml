/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.15 //.12
import QtQuick.Controls         2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.3
import QtQuick.Dialogs          1.3
import QtQuick.Layouts          1.12
import QtCharts 2.1

import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Window           2.2
import QtQml.Models             2.1
//import Qt.labs.qmlmodels 1.0

import QGroundControl               1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0


// To implement a custom overlay copy this code to your own control in your custom code source. Then override the
// FlyViewCustomLayer.qml resource with your own qml. See the custom example and documentation for details.
Item {
    id: _root
    anchors.right: FlightDisplayViewWidgets.left

    property var parentToolInsets               // These insets tell you what screen real estate is available for positioning the controls in your overlay
    property var totalToolInsets:   _toolInsets // These are the insets for your custom overlay additions
    property var mapControl
//    QGCPalette { id: palette; colorGroupEnabled: enabled }

//    anchors.fill: parent
//    width:          1200
//    height: 600
//    anchors.top:    parent.top

//    width:  ScreenTools.defaultFontPixelHeight * 10 // No hardcoded sizing. All sizing must be relative to a ScreenTools font size
//    height: ScreenTools.defaultFontPixelHeight * 20
//    anchors.bottom: parent.bottom
//    anchors.left: parent.left
//    visible:        QGroundControl.pairingManager.usePairing

//    property bool _light:               qgcPal.globalTheme === QGCPalette.Light && !activeVehicle
//    property real _contentWidth:        ScreenTools.defaultFontPixelWidth  * 100
//    property real _contentSpacing:      ScreenTools.defaultFontPixelHeight * 50
//    property real _rectWidth:           _contentWidth
//    property real _rectHeight:          _contentWidth * 0.75

    QGCToolInsets {
        id:                         _toolInsets
//        leftEdgeCenterInset:    0
//        leftEdgeTopInset:           0
//        leftEdgeBottomInset:        parentToolInsets.leftEdgeBottomInset
//        rightEdgeCenterInset:   0
//        rightEdgeTopInset:          0
        rightEdgeBottomInset:       parent.width +  ScreenTools.defaultFontPixelHeight * 6
        topEdgeCenterInset:       ScreenTools.defaultFontPixelHeight * 6
//        topEdgeLeftInset:           parentToolInsets.topEdgeLeftInset
//        topEdgeRightInset:          0
//        bottomEdgeCenterInset:    0
//        bottomEdgeLeftInset:        0
//        bottomEdgeRightInset:       0
    }

//    QGCToolInsets {
//        id:                     _totalToolInsets
////        leftEdgeTopInset:       toolStrip.leftInset
////        leftEdgeCenterInset:    toolStrip.leftInset
//        leftEdgeBottomInset:    parentToolInsets.leftEdgeBottomInset
//        rightEdgeTopInset:      parentToolInsets.rightEdgeTopInset
//        rightEdgeCenterInset:   parentToolInsets.rightEdgeCenterInset
//        rightEdgeBottomInset:   parentToolInsets.rightEdgeBottomInset
//        topEdgeLeftInset:       parentToolInsets.topEdgeLeftInset
//        topEdgeCenterInset:     parentToolInsets.topEdgeCenterInset
//        topEdgeRightInset:      parentToolInsets.topEdgeRightInset
//        bottomEdgeLeftInset:    parentToolInsets.bottomEdgeLeftInset
////        bottomEdgeCenterInset:  mapScale.centerInset
//        bottomEdgeRightInset:   0
//    }



    Popup {
           id: popup
           width: parent.width/3
           height: parent.height/3
//           contentWidth: popupWindow.implicitWidth
//           contentHeight: popupWindow.implicitHeight
           anchors.centerIn: parent
           padding: 2

           modal: true
           focus: true

           Rectangle {
               id: popupWindow
               color: qgcPal.button
               width: parent.width
               height: parent.height

//          property real _toolButtonHeight:    ScreenTools.defaultFontPixelHeight * 3
          property real _margins:             ScreenTools.defaultFontPixelWidth


               ColumnLayout {
                   id: sensorTableColumn
                   spacing: 5
                   Layout.fillHeight: true
                   width: parent.width
                   anchors.bottom: parent.bottom
                   anchors.top: parent.top
                   anchors.margins: _margins


                   // Temporary Placeholder Data
                   ListModel {
                       id: sensorCoordsModel
                       ListElement {
                           coords: "40.6049° N, 75.3775° W"
                           methaneppm: "50,000"
                       }
                       ListElement {
                           coords: "40.6049° N, 75.3775° W"
                           methaneppm: "60,000"
                       }
                       ListElement {
                           coords: "40.6049° N, 75.3775° W"
                           methaneppm: "65,000"
                       }
                   }

                   Rectangle {
                       id: titleArea
                       height: closeButton.height
                       color: qgcPal.button
                       Layout.fillWidth:   true


                       RowLayout {
                           id: titleRowLayout
                           Layout.fillWidth:   true
                           width: parent.width


                           QGCLabel {
                               Layout.leftMargin:  ScreenTools.defaultFontPixelWidth * 2
//                               Layout.rightMargin:  closeButton.leftMargin
                               width: parent.width //- closeButton.width
                               text:               "Locations of High Methane Concentration"
                               font.pointSize:     ScreenTools.mediumFontPointSize
//                               verticalAlignment:	Text.AlignVLeft
                               Layout.alignment: Text.AlignHCenter
                           }


                           QGCButton {
                               id: closeButton
                               width: parent.height
                               height: parent.height
                               primary: true
                               icon.source: "qrc:/res/XDeleteBlack.svg"
                               onClicked:  popup.close()
                               Layout.rightMargin: _margins * 2
                               Layout.alignment: Qt.AlignRight
                               padding: _margins
                               Image {
                                   source: closeButton.icon.source
                                   width: closeButton.icon.width
                                   height: closeButton.icon.height
                                   anchors.verticalCenter: parent.verticalCenter
                                   anchors.horizontalCenter: parent.horizontalCenter
                               }
                           }
                       }
                   }

                   TableView{
                       id: sensorValuesTable
                       backgroundVisible: false
                       height: parent.height // - titleArea.height
                       Layout.fillWidth:   true
                       Layout.fillHeight:   true
                       horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                       verticalScrollBarPolicy: Qt.ScrollBarAlwaysOn
                       clip: false
           //            model:              logController.model
                       model:              sensorCoordsModel
    //                   onModelChanged: {
    //                       sensorValuesTable.height = sensorValuesTable.model.count*(listitem_height+spacing)
    //                   }
       //                flickableDirection: Flickable.VerticalFlick
           //            property color indicatorColor: qgcPal.text

                       style: TableViewStyle {

                           backgroundColor: qgcPal.button
                           alternateBackgroundColor: qgcPal.button
                           headerDelegate: Rectangle {
                               height: 20
                               color: qgcPal.primaryButton
                               Text {
                                   width: parent.width / 2 // <---
                                   anchors.centerIn: parent
                                   Layout.fillWidth:   true
                                   text: styleData.value
                                   //elide: Text.ElideMiddle

                               }
                           }

                           itemDelegate: Rectangle {
                               id: dataEntries
//                               implicitHeight: rowText.paintedHeight
                               Text {
                                   id: rowText
                                   color: "black"
                                   anchors.centerIn: parent
                                   width: parent.width / 2 // <---
                                   Layout.fillWidth:   true
                                   text: styleData.value
                                   //elide: Text.ElideMiddle

                               }
//                               color: "#878797"
                               color: model.row % 2 == 0 ? "#878797" : "#BEBEC6"
//                               implicitHeight: sensorValuesTable.rowHeightProvider(row)
                           }
                       }

                       TableViewColumn {
                           role: "coords"
                           title: "Coordinates"
                           width: sensorValuesTable.width / 2
                           horizontalAlignment: Text.AlignHCenter

                       }
                       TableViewColumn {
                           role: "methaneppm"
                           title: "Methane Concentration (ppm)"
                           width: sensorValuesTable.width / 2
                           horizontalAlignment: Text.AlignHCenter
                       }

                   }

               }
       }
    }


    Rectangle {
        QGCPalette { id: qgcPal; colorGroupEnabled: enabled }

        width: parent.width/3
        height: parent.height/3
        color: qgcPal.window
        anchors.bottom: parent.bottom
        anchors.margins:  _margins
        anchors.left: parent.left


        ChartView {
            id: chartView
            anchors.top: parent.top
            anchors.bottom: sensorDataBtn.top
            anchors.right: parent.right
            width: parent.width
            animationOptions: ChartView.NoAnimation
            theme: ChartView.ChartThemeDark
            backgroundColor: qgcPal.window
            legend.visible: true
            legend.color: "white"
            title: "Real-Time Methane Detection"
            titleFont.pixelSize:  ScreenTools.defaultFontPointSize * 1.5
            titleColor: "white"
            titleFont.family:  ScreenTools.normalFontFamily

//            theme: ChartView.ChartThemeLight
//            backgroundColor: "#D3D3D9"
//            legend.visible: true
//            legend.color: "black"
//            title: "Real-Time Methane Detection"
//            titleFont.pixelSize:  ScreenTools.defaultFontPointSize * 1.5
//            titleColor: "black"
//            titleFont.family:  ScreenTools.normalFontFamily

            ValueAxis {
                id: axisY
                min: 0
                max: 70000
                tickCount: 8
                titleText: "Methane Detected (ppm)"
                labelsColor: "white"
                color: "white"

            }

            DateTimeAxis {
              id: axisX
              gridVisible: true
              format: "hh:mm:ss"
              tickCount: 10
              titleText: "Time (hh:mm:ss)"
              titleFont.bold: true
              titleFont.italic: true
              titleFont.pointSize: 10
              min: getXmin()
              max: getXmax()
              labelsColor: "white"
              color: "white"
            }


            LineSeries {
                id: constantPPM
                name: "Critical Methane Threshold"
                XYPoint { x: getTimeS() - 5; y: 55000 } // Initial data point
                XYPoint { x: getTimeS(); y: 55000 } // Initial data point
                axisX: axisX
                axisY: axisY
                color: "#9653DE"
                width: 3
                pointLabelsColor: "white"
            }

            LineSeries {
                id: dataSeries
                name: "Methane Detected"
                axisX: axisX
                axisY: axisY
                color: "#5ECBF1"
                width: 3
                pointLabelsColor: "white"
            }

            // Update x-axis values periodically
            Timer {
                id: realtimeTimer
                property int amountOfData: 0 //So we know when we need to start scrolling

                interval: 250 // Update every 0.25 second
                running: true
                repeat: true
                onTriggered: {
                    var now = new Date();
                    var totalSeconds = now.getHours() * 3600 + now.getMinutes() * 60 + now.getSeconds();
                    var max = 70000;
                    var min = 30000;
                    var yVal = Math.floor(Math.random() * (max - min + 1)) + min;
                    dataSeries.append(now, yVal);
                    constantPPM.append(now, 55000);
                    if(amountOfData > 4){
                        axisX.min = getXmin();
                        axisX.max = getXmax();
                    }else{
                        amountOfData++; //This else is just to stop incrementing the variable unnecessarily
                    }
                }
            }
        }

        QGCButton {
            id: sensorDataBtn
            text: "View Logged High Methane Detection Levels"
            onClicked: popup.open()
            anchors.bottomMargin: _margins * 4
            anchors.leftMargin: _margins * 2
            anchors.topMargin: _margins
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            height: parent/5
        }

    }

    function getTimeS() {
        var now = new Date();
        var timeS = now.getHours() * 3600 + now.getMinutes() * 60 + now.getSeconds();
        return timeS;
    }

    function getXmin() {
        var currentTime = new Date();
        currentTime.setSeconds(currentTime.getSeconds() - 5);
        return currentTime
    }

    function getXmax() {
        var currentTime = new Date();
        return currentTime

    }
}


