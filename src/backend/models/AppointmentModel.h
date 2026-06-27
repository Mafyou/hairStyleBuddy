#pragma once

#include <QAbstractListModel>
#include "../services/LocalDbService.h"

class AppointmentModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        ClientNameRole,
        TimeRole,
        ServiceRole,
        ArrivedRole
    };

    explicit AppointmentModel(LocalDbService *db, QObject *parent = nullptr);

    int      rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void reload();

private:
    LocalDbService     *m_db;
    QList<Appointment>  m_data;
};
