#pragma once

#include <QAbstractListModel>
#include <QList>
#include <QString>
#include <QStringList>

struct Service {
    int         id;
    QString     category;
    QString     name;
    QString     subtitle;
    int         processingMinutes;
    QStringList steps;
};

class ServiceModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        CategoryRole,
        NameRole,
        SubtitleRole,
        ProcessingRole,
        StepsRole
    };

    explicit ServiceModel(QObject *parent = nullptr);

    int      rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    QList<Service> m_data;
};
