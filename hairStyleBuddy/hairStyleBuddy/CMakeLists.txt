cmake_minimum_required(VERSION 3.16)
project(hairStyleBuddy VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Sql)

qt_standard_project_setup()

qt_add_executable(hairStyleBuddy
    src/main.cpp
    src/backend/AppController.h
    src/backend/AppController.cpp
    src/backend/models/AppointmentModel.h
    src/backend/models/AppointmentModel.cpp
    src/backend/models/ServiceModel.h
    src/backend/models/ServiceModel.cpp
    src/backend/services/LocalDbService.h
    src/backend/services/LocalDbService.cpp
    src/backend/services/SettingsService.h
    src/backend/services/SettingsService.cpp
)

qt_add_qml_module(hairStyleBuddy
    URI HairStyleBuddy
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/ActionTile.qml
        qml/PageHeader.qml
        qml/HomePage.qml
        qml/AppointmentsPage.qml
        qml/ServicesPage.qml
)

target_include_directories(hairStyleBuddy PRIVATE src)

target_link_libraries(hairStyleBuddy
    PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Sql
)
