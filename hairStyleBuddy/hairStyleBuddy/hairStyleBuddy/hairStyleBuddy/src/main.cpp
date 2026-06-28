#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "backend/AppController.h"

int main(int argc, char *argv[])
{
    qputenv("QT_QUICK_CONTROLS_STYLE", "Basic");

    QGuiApplication app(argc, argv);
    app.setOrganizationName("HairStyleBuddy");
    app.setApplicationName("HairStyleBuddy");

    AppController controller;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appController", &controller);
    engine.loadFromModule("HairStyleBuddy", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
