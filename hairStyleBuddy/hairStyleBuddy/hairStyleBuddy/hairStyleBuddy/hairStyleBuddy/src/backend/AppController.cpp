#include "AppController.h"

AppController::AppController(QObject *parent)
    : QObject(parent)
    , m_db(new LocalDbService(this))
    , m_settings(new SettingsService(this))
    , m_appointments(new AppointmentModel(m_db, this))
    , m_services(new ServiceModel(m_db, this))
{
    connect(m_settings, &SettingsService::settingChanged, this, [this](const QString &key) {
        if (key == "salonName")
            emit salonNameChanged();
    });

    m_db->initialize();
    refresh();
}

QString AppController::salonName() const
{
    return m_settings->value("salonName", "Mon Salon").toString();
}

void AppController::markArrived(int appointmentId)
{
    m_db->setAppointmentArrived(appointmentId, true);
    m_appointments->reload();
}

void AppController::addQuickNote(const QString &note)
{
    m_db->insertQuickNote(note);
}

void AppController::refresh()
{
    m_appointments->reload();
    m_services->reload();
}
