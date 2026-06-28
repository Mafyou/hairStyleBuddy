#pragma once

#include <QObject>
#include <QString>

#include "models/AppointmentModel.h"
#include "models/ServiceModel.h"
#include "services/LocalDbService.h"
#include "services/SettingsService.h"

class AppController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(AppointmentModel* appointments READ appointments CONSTANT)
    Q_PROPERTY(ServiceModel*     services     READ services     CONSTANT)
    Q_PROPERTY(QString           salonName    READ salonName    NOTIFY salonNameChanged)

public:
    explicit AppController(QObject *parent = nullptr);

    AppointmentModel* appointments() const { return m_appointments; }
    ServiceModel*     services()     const { return m_services; }
    QString           salonName()    const;

public slots:
    void markArrived(int appointmentId);
    void addQuickNote(const QString &note);
    void refresh();

signals:
    void salonNameChanged();

private:
    LocalDbService   *m_db;
    SettingsService  *m_settings;
    AppointmentModel *m_appointments;
    ServiceModel     *m_services;
};
