#pragma once

#include <QObject>
#include <QString>

#include "models/AppointmentModel.h"
#include "models/ServiceModel.h"

class AppController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(AppointmentModel* appointments READ appointments CONSTANT)
    Q_PROPERTY(ServiceModel*     services     READ services     CONSTANT)
    Q_PROPERTY(QString           salonName    READ salonName    CONSTANT)

public:
    explicit AppController(QObject *parent = nullptr);

    AppointmentModel* appointments() const { return m_appointments; }
    ServiceModel*     services()     const { return m_services; }
    QString           salonName()    const { return "Mon Salon"; }

public slots:
    void markArrived(int appointmentId);

private:
    AppointmentModel *m_appointments;
    ServiceModel     *m_services;
};
