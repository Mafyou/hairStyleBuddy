#include "AppointmentModel.h"

AppointmentModel::AppointmentModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_data({
        { 1, "Sophie Martin",   "09:00", "Coupe + brushing femme", false },
        { 2, "Emma Dubois",     "10:30", "Couleur complète",       false },
        { 3, "Claire Bernard",  "14:00", "Balayage soleil",        false },
        { 4, "Julie Moreau",    "15:30", "Soin réparateur",        false },
        { 5, "Isabelle Petit",  "16:30", "Coupe femme",            false },
    })
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

void AppointmentModel::markArrived(int id)
{
    for (int i = 0; i < m_data.size(); ++i) {
        if (m_data[i].id == id) {
            m_data[i].arrived = true;
            const QModelIndex idx = index(i);
            emit dataChanged(idx, idx, { ArrivedRole });
            return;
        }
    }
}
