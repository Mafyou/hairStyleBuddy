#include "SettingsService.h"

#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonValue>

SettingsService::SettingsService(QObject *parent)
    : QObject(parent)
{
    const QString configDir = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation);
    QDir().mkpath(configDir);
    m_configPath = configDir + "/config.json";
    load();
}

QVariant SettingsService::value(const QString &key, const QVariant &defaultValue) const
{
    if (!m_config.contains(key))
        return defaultValue;
    return m_config.value(key).toVariant();
}

void SettingsService::setValue(const QString &key, const QVariant &value)
{
    m_config[key] = QJsonValue::fromVariant(value);
    save();
    emit settingChanged(key);
}

void SettingsService::load()
{
    QFile f(m_configPath);
    if (!f.open(QIODevice::ReadOnly))
        return;
    m_config = QJsonDocument::fromJson(f.readAll()).object();
}

void SettingsService::save() const
{
    QFile f(m_configPath);
    if (!f.open(QIODevice::WriteOnly))
        return;
    f.write(QJsonDocument(m_config).toJson(QJsonDocument::Indented));
}
