import QtQuick
import QtQuick.Controls
import HairStyleBuddy

Page {
    id: detailPage

    property string serviceName:       ""
    property string serviceSubtitle:   ""
    property string serviceCategory:   ""
    property int    serviceProcessing: 0
    property var    serviceSteps:      []

    header: PageHeader {
        title: detailPage.serviceName
        onBack: detailPage.StackView.view.pop()
    }

    background: Rectangle { color: "#FAFAFA" }

    function accentColor(cat) {
        switch (cat) {
        case "Couleur":  return "#C2185B"
        case "Soin":     return "#2E7D32"
        case "Coupe":    return "#1565C0"
        case "Balayage": return "#E65100"
        default:         return "#1C1C1E"
        }
    }

    function bgColor(cat) {
        switch (cat) {
        case "Couleur":  return "#FCE4EC"
        case "Soin":     return "#E8F5E9"
        case "Coupe":    return "#E3F2FD"
        case "Balayage": return "#FFF8E1"
        default:         return "#F5F5F5"
        }
    }

    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth

        Column {
            width: scroll.availableWidth
            spacing: 10
            topPadding: 14
            bottomPadding: 14
            leftPadding: 14
            rightPadding: 14

            // ── Bandeau sous-titre (oxydant, type de soin, etc.) ──────────────
            Rectangle {
                width: parent.width - parent.leftPadding - parent.rightPadding
                height: subText.implicitHeight + 24
                radius: 12
                color: bgColor(serviceCategory)

                Text {
                    id: subText
                    anchors { fill: parent; margins: 12 }
                    text: serviceSubtitle
                    font.pixelSize: 15
                    font.weight: Font.Medium
                    color: accentColor(serviceCategory)
                    wrapMode: Text.WordWrap
                }
            }

            // ── Badge temps de pose ───────────────────────────────────────────
            Rectangle {
                width: parent.width - parent.leftPadding - parent.rightPadding
                height: 52
                radius: 12
                color: "#F0F0F0"
                visible: serviceProcessing > 0

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "⏱"
                        font.pixelSize: 20
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "Temps de pose : <b>" + serviceProcessing + " min</b>"
                        font.pixelSize: 16
                        color: accentColor(serviceCategory)
                        textFormat: Text.RichText
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // ── Liste des étapes ──────────────────────────────────────────────
            Rectangle {
                width: parent.width - parent.leftPadding - parent.rightPadding
                height: stepsCol.implicitHeight + 24
                radius: 12
                color: "#FFFFFF"

                Column {
                    id: stepsCol
                    anchors { fill: parent; margins: 16 }
                    spacing: 14

                    Text {
                        text: "ÉTAPES"
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        font.letterSpacing: 2
                        color: "#AAAAAA"
                    }

                    Repeater {
                        model: detailPage.serviceSteps

                        Item {
                            width: stepsCol.width
                            height: Math.max(numCircle.height, stepLabel.implicitHeight)

                            Rectangle {
                                id: numCircle
                                width: 30
                                height: 30
                                radius: 15
                                color: accentColor(serviceCategory)
                                anchors { left: parent.left; top: parent.top }

                                Text {
                                    anchors.centerIn: parent
                                    text: index + 1
                                    font.pixelSize: 14
                                    font.weight: Font.Bold
                                    color: "#FFFFFF"
                                }
                            }

                            Text {
                                id: stepLabel
                                anchors {
                                    left: numCircle.right
                                    leftMargin: 12
                                    right: parent.right
                                    top: parent.top
                                    topMargin: 5
                                }
                                text: modelData
                                font.pixelSize: 15
                                color: "#1C1C1E"
                                wrapMode: Text.WordWrap
                                lineHeight: 1.3
                            }
                        }
                    }
                }
            }
        }
    }
}
