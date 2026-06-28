#include "LocalDbService.h"

#include <QSqlQuery>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QDate>
#include <QDebug>

LocalDbService::LocalDbService(QObject *parent)
    : QObject(parent)
{}

void LocalDbService::initialize()
{
    const QString dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(dataDir);

    m_db = QSqlDatabase::addDatabase("QSQLITE", "main");
    m_db.setDatabaseName(dataDir + "/hairstylebuddy.db");

    if (!m_db.open()) {
        qWarning() << "Cannot open database:" << m_db.lastError().text();
        return;
    }

    createTables();
    seedDefaultData();
}

void LocalDbService::createTables()
{
    QSqlQuery q(m_db);

    q.exec(R"(
        CREATE TABLE IF NOT EXISTS appointments (
            id           INTEGER PRIMARY KEY AUTOINCREMENT,
            client_name  TEXT    NOT NULL,
            time         TEXT    NOT NULL,
            service      TEXT    NOT NULL,
            date         TEXT    NOT NULL,
            arrived      INTEGER NOT NULL DEFAULT 0
        )
    )");

    q.exec(R"(
        CREATE TABLE IF NOT EXISTS services (
            id               INTEGER PRIMARY KEY AUTOINCREMENT,
            name             TEXT    NOT NULL,
            duration_minutes INTEGER NOT NULL,
            price            REAL    NOT NULL
        )
    )");

    q.exec(R"(
        CREATE TABLE IF NOT EXISTS quick_notes (
            id         INTEGER PRIMARY KEY AUTOINCREMENT,
            content    TEXT    NOT NULL,
            created_at TEXT    NOT NULL DEFAULT (datetime('now'))
        )
    )");
}

void LocalDbService::seedDefaultData()
{
    QSqlQuery q(m_db);

    q.exec("SELECT COUNT(*) FROM services");
    if (q.next() && q.value(0).toInt() == 0) {
        const QList<std::tuple<QString, int, double>> defaultServices = {
            { "Coupe femme",  45,  35.0 },
            { "Coupe homme",  30,  20.0 },
            { "Couleur",      90,  65.0 },
            { "Balayage",    120,  85.0 },
            { "Brushing",     30,  25.0 },
            { "Soin",         20,  15.0 },
        };
        for (const auto &[name, duration, price] : defaultServices) {
            QSqlQuery ins(m_db);
            ins.prepare("INSERT INTO services (name, duration_minutes, price) VALUES (?, ?, ?)");
            ins.addBindValue(name);
            ins.addBindValue(duration);
            ins.addBindValue(price);
            ins.exec();
        }
    }

    // Seed sample appointments for today on first launch
    q.prepare("SELECT COUNT(*) FROM appointments WHERE date = ?");
    q.addBindValue(QDate::currentDate().toString(Qt::ISODate));
    q.exec();
    if (q.next() && q.value(0).toInt() == 0) {
        const QString today = QDate::currentDate().toString(Qt::ISODate);
        const QList<std::tuple<QString, QString, QString>> samples = {
            { "09:00", "Sophie Martin",   "Coupe femme"  },
            { "10:30", "Emma Dubois",     "Couleur"      },
            { "14:00", "Claire Bernard",  "Brushing"     },
            { "15:30", "Julie Moreau",    "Balayage"     },
        };
        for (const auto &[time, client, service] : samples) {
            QSqlQuery ins(m_db);
            ins.prepare("INSERT INTO appointments (client_name, time, service, date) VALUES (?, ?, ?, ?)");
            ins.addBindValue(client);
            ins.addBindValue(time);
            ins.addBindValue(service);
            ins.addBindValue(today);
            ins.exec();
        }
    }
}

QList<Appointment> LocalDbService::todayAppointments()
{
    QList<Appointment> list;
    QSqlQuery q(m_db);
    q.prepare(
        "SELECT id, client_name, time, service, arrived "
        "FROM appointments WHERE date = ? ORDER BY time"
    );
    q.addBindValue(QDate::currentDate().toString(Qt::ISODate));
    q.exec();

    while (q.next()) {
        list.append({
            q.value(0).toInt(),
            q.value(1).toString(),
            q.value(2).toString(),
            q.value(3).toString(),
            q.value(4).toBool()
        });
    }
    return list;
}

void LocalDbService::setAppointmentArrived(int id, bool arrived)
{
    QSqlQuery q(m_db);
    q.prepare("UPDATE appointments SET arrived = ? WHERE id = ?");
    q.addBindValue(arrived ? 1 : 0);
    q.addBindValue(id);
    q.exec();
}

void LocalDbService::insertQuickNote(const QString &note)
{
    QSqlQuery q(m_db);
    q.prepare("INSERT INTO quick_notes (content) VALUES (?)");
    q.addBindValue(note);
    q.exec();
}

QList<Service> LocalDbService::allServices()
{
    QList<Service> list;
    QSqlQuery q(m_db);
    q.exec("SELECT id, name, duration_minutes, price FROM services ORDER BY name");

    while (q.next()) {
        list.append({
            q.value(0).toInt(),
            q.value(1).toString(),
            q.value(2).toInt(),
            q.value(3).toDouble()
        });
    }
    return list;
}
