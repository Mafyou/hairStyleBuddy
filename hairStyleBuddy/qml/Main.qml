import QtQuick
import QtQuick.Controls
import HairStyleBuddy

ApplicationWindow {
    id: root
    visible: true
    title: appController.salonName
    visibility: Window.FullScreen

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: homeComp
    }

    Component {
        id: homeComp
        HomePage {
            onGoToAppointments: stack.push(appointmentsComp)
            onGoToServices:     stack.push(servicesComp)
            onGoToNotes:        stack.push(notesComp)
        }
    }

    Component {
        id: appointmentsComp
        AppointmentsPage {}
    }

    Component {
        id: servicesComp
        ServicesPage {}
    }

    // Placeholder — à implémenter en V2
    Component {
        id: notesComp
        Page {
            header: PageHeader { title: "Note rapide"; onBack: stack.pop() }
            Label {
                anchors.centerIn: parent
                text: "Fonctionnalité à venir"
                font.pixelSize: 18
                color: "#8E8E93"
            }
        }
    }
}
