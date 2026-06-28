#pragma once

#include <QObject>
#include <QVariant>
#include <QJsonObject>

class SettingsService : public QObject
{
    Q_OBJECT

public:
    explicit SettingsService(QObject *parent = nullptr);

    QVariant value(const QString &key, const QVariant &defaultValue = {}) const;
    void setValue(const QString &key, const QVariant &value);

signals:
    void settingChanged(const QString &key);

private:
    void load();
    void save() const;

    QJsonObject m_config;
    QString     m_configPath;
};
