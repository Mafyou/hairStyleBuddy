import QtQuick
import QtQuick.Controls
import HairStyleBuddy

ApplicationWindow {
    id: root
    width: 800
    height: 480
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
            onGoToCategory: (cat) => stack.push(servicesComp, { category: cat })
        }
    }

    Component {
        id: servicesComp
        ServicesPage {}
    }
}
