#include "AppController.h"

AppController::AppController(QObject *parent)
    : QObject(parent)
    , m_appointments(new AppointmentModel(this))
    , m_services(new ServiceModel(this))
{}

void AppController::markArrived(int appointmentId)
{
    m_appointments->markArrived(appointmentId);
}
