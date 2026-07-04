import QtQuick
import QtQuick.Controls
import HairStyleBuddy

Page {
    id: page

    property string category: ""

    header: PageHeader {
        title: page.category === "" ? "Référence" : page.category
        onBack: page.StackView.view.pop()
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

    function sectionBg(cat) {
        switch (cat) {
        case "Couleur":  return "#FCE4EC"
        case "Soin":     return "#E8F5E9"
        case "Coupe":    return "#E3F2FD"
        case "Balayage": return "#FFF8E1"
        default:         return "#F5F5F5"
        }
    }

    Component {
        id: detailComp
        ServiceDetailPage {}
    }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6
        model: appController.services
        clip: true

        section.property: page.category === "" ? "category" : ""
        section.criteria: ViewSection.FullString

        section.delegate: Rectangle {
            width: listView.width
            height: 44
            radius: 10
            color: sectionBg(section)

            Text {
                anchors { left: parent.left; leftMargin: 16; verticalCenter: parent.verticalCenter }
                text: section.toUpperCase()
                font.pixelSize: 15
                font.weight: Font.Bold
                font.letterSpacing: 1
                color: accentColor(section)
            }
        }

        delegate: Item {
            width: listView.width
            property bool matches: page.category === "" || category === page.category
            height: matches ? 78 : 0
            visible: matches
            clip: true

            Rectangle {
                anchors.fill: parent
                radius: 10
                color: itemTap.pressed ? sectionBg(category) : "#FFFFFF"

                Behavior on color { ColorAnimation { duration: 80 } }

                // Barre gauche colorée
                Rectangle {
                    width: 5
                    height: parent.height - 20
                    radius: 3
                    color: accentColor(category)
                    anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                }

                // Flèche droite
                Text {
                    anchors { right: parent.right; rightMargin: 14; verticalCenter: parent.verticalCenter }
                    text: "›"
                    font.pixelSize: 28
                    color: accentColor(category)
                    opacity: 0.5
                }

                Row {
                    anchors {
                        fill: parent
                        leftMargin: 16
                        rightMargin: 40
                    }

                    Column {
                        width: parent.width - (processing > 0 ? 80 : 0)
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 6

                        Text {
                            width: parent.width
                            text: name
                            font.pixelSize: 17
                            font.weight: Font.SemiBold
                            color: "#1C1C1E"
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width
                            text: subtitle
                            font.pixelSize: 13
                            color: accentColor(category)
                            elide: Text.ElideRight
                        }
                    }

                    Column {
                        width: 80
                        anchors.verticalCenter: parent.verticalCenter
                        visible: processing > 0
                        spacing: 2

                        Text {
                            width: parent.width
                            text: processing + " min"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: accentColor(category)
                            horizontalAlignment: Text.AlignRight
                        }

                        Text {
                            width: parent.width
                            text: "de pose"
                            font.pixelSize: 11
                            color: "#8E8E93"
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                }

                Rectangle {
                    width: parent.width - 32
                    height: 1
                    color: "#F0F0F0"
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                TapHandler {
                    id: itemTap
                    onTapped: page.StackView.view.push(detailComp, {
                        serviceName:       name,
                        serviceSubtitle:   subtitle,
                        serviceCategory:   category,
                        serviceProcessing: processing,
                        serviceSteps:      steps
                    })
                }
            }
        }
    }
}
