#pragma once

#include <QObject>
#include <QSqlDatabase>
#include <QList>
#include <QString>

struct Appointment {
    int     id;
    QString clientName;
    QString time;
    QString service;
    bool    arrived;
};

struct Service {
    int     id;
    QString name;
    int     durationMinutes;
    double  price;
};

class LocalDbService : public QObject
{
    Q_OBJECT

public:
    explicit LocalDbService(QObject *parent = nullptr);

    void initialize();

    QList<Appointment> todayAppointments();
    void setAppointmentArrived(int id, bool arrived);
    void insertQuickNote(const QString &note);

    QList<Service> allServices();

private:
    void createTables();
    void seedDefaultData();

    QSqlDatabase m_db;
};
