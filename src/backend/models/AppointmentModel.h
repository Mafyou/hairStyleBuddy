#pragma once

#include <QAbstractListModel>
#include <QList>
#include <QString>

struct Appointment {
    int     id;
    QString clientName;
    QString time;
    QString service;
    bool    arrived;
};

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

    explicit AppointmentModel(QObject *parent = nullptr);

    int      rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void markArrived(int id);

private:
    QList<Appointment> m_data;
};
