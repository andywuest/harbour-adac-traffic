#ifndef TRAFFICMANAGER_H
#define TRAFFICMANAGER_H

#include <QNetworkAccessManager>
#include <QNetworkConfigurationManager>
#include <QObject>
#include <QSettings>

#include "adacbackend.h"

class TrafficManager : public QObject
{
    Q_OBJECT
public:
    explicit TrafficManager(QObject *parent = nullptr);
    ~TrafficManager() = default;

    ADACBackend *getAdacBackend();

private:
    QNetworkAccessManager *const networkAccessManager;
    QNetworkConfigurationManager *const networkConfigurationManager;

    ADACBackend *adacBackend;

    QSettings settings;

};

#endif // TRAFFICMANAGER_H
