#include "ServiceModel.h"

ServiceModel::ServiceModel(LocalDbService *db, QObject *parent)
    : QAbstractListModel(parent), m_db(db)
{}

int ServiceModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_data.size();
}

QVariant ServiceModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_data.size())
        return {};

    const Service &s = m_data.at(index.row());
    switch (role) {
    case IdRole:       return s.id;
    case NameRole:     return s.name;
    case DurationRole: return s.durationMinutes;
    case PriceRole:    return s.price;
    default:           return {};
    }
}

QHash<int, QByteArray> ServiceModel::roleNames() const
{
    return {
        { IdRole,       "serviceId" },
        { NameRole,     "name"      },
        { DurationRole, "duration"  },
        { PriceRole,    "price"     },
    };
}

void ServiceModel::reload()
{
    beginResetModel();
    m_data = m_db->allServices();
    endResetModel();
}
