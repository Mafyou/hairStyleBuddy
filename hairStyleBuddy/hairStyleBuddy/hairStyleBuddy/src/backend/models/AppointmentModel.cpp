#include "AppointmentModel.h"

AppointmentModel::AppointmentModel(LocalDbService *db, QObject *parent)
    : QAbstractListModel(parent), m_db(db)
{}

int AppointmentModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_data.size();
}

QVariant AppointmentModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_data.size())
        return {};

    const Appointment &a = m_data.at(index.row());
    switch (role) {
    case IdRole:         return a.id;
    case ClientNameRole: return a.clientName;
    case TimeRole:       return a.time;
    case ServiceRole:    return a.service;
    case ArrivedRole:    return a.arrived;
    default:             return {};
    }
}

QHash<int, QByteArray> AppointmentModel::roleNames() const
{
    return {
        { IdRole,         "appointmentId" },
        { ClientNameRole, "clientName"    },
        { TimeRole,       "apptTime"      },
        { ServiceRole,    "service"       },
        { ArrivedRole,    "arrived"       },
    };
}

void AppointmentModel::reload()
{
    beginResetModel();
    m_data = m_db->todayAppointments();
    endResetModel();
}
